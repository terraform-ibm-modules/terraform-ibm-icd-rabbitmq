// Tests in this file are run in the PR pipeline
package test

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const standardSolutionTerraformDir = "solutions/standard"

// Use existing resource group
const resourceGroup = "geretain-test-rabbitmq"

// Restricting due to limited availability of BYOK in certain regions
const regionSelectionPath = "../common-dev-assets/common-go-assets/icd-region-prefs.yaml"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

var sharedInfoSvc *cloudinfo.CloudInfoService

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})

	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

type tarIncludePatterns struct {
	excludeDirs []string

	includeFiletypes []string

	includeDirs []string
}

func getTarIncludePatternsRecursively(dir string, dirsToExclude []string, fileTypesToInclude []string) ([]string, error) {
	r := tarIncludePatterns{dirsToExclude, fileTypesToInclude, nil}
	err := filepath.WalkDir(dir, func(path string, entry fs.DirEntry, err error) error {
		return walk(&r, path, entry, err)
	})
	if err != nil {
		fmt.Println("error")
		return r.includeDirs, err
	}
	return r.includeDirs, nil
}

func walk(r *tarIncludePatterns, s string, d fs.DirEntry, err error) error {
	if err != nil {
		return err
	}
	if d.IsDir() {
		for _, excludeDir := range r.excludeDirs {
			if strings.Contains(s, excludeDir) {
				return nil
			}
		}
		if s == ".." {
			r.includeDirs = append(r.includeDirs, "*.tf")
			return nil
		}
		for _, includeFiletype := range r.includeFiletypes {
			r.includeDirs = append(r.includeDirs, strings.ReplaceAll(s+"/*"+includeFiletype, "../", ""))
		}
	}
	return nil
}

func TestRunStandardSolutionSchematics(t *testing.T) {
	t.Parallel()

	excludeDirs := []string{
		".terraform",
		".docs",
		".github",
		".git",
		".idea",
		"common-dev-assets",
		"examples",
		"tests",
		"reference-architectures",
	}
	includeFiletypes := []string{
		".tf",
		".yaml",
		".py",
		".tpl",
		".sh",
	}

	tarIncludePatterns, recurseErr := getTarIncludePatternsRecursively("..", excludeDirs, includeFiletypes)

	// if error producing tar patterns (very unexpected) fail test immediately
	require.NoError(t, recurseErr, "Schematic Test had unexpected error traversing directory tree")
	prefix := "rabbitmq-st-da"
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:                t,
		TarIncludePatterns:     tarIncludePatterns,
		TemplateFolder:         standardSolutionTerraformDir,
		BestRegionYAMLPath:     regionSelectionPath,
		Prefix:                 prefix,
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	serviceCredentialSecrets := []map[string]interface{}{
		{
			"secret_group_name": fmt.Sprintf("%s-secret-group", options.Prefix),
			"service_credentials": []map[string]string{
				{
					"secret_name": fmt.Sprintf("%s-cred-reader", options.Prefix),
					"service_credentials_source_service_role": "Reader",
				},
				{
					"secret_name": fmt.Sprintf("%s-cred-writer", options.Prefix),
					"service_credentials_source_service_role": "Writer",
				},
			},
		},
	}

	serviceCredentialNames := map[string]string{
		"admin": "Administrator",
		"user1": "Viewer",
		"user2": "Editor",
	}

	serviceCredentialNamesJSON, err := json.Marshal(serviceCredentialNames)
	if err != nil {
		log.Fatalf("Error converting to JSON: %s", err)
	}

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "existing_kms_instance_crn", Value: permanentResources["hpcs_south_crn"], DataType: "string"},
		{Name: "kms_endpoint_type", Value: "private", DataType: "string"},
		{Name: "rabbitmq_version", Value: "3.13", DataType: "string"}, // Always lock this test into the latest supported RabbitMQ version
		{Name: "resource_group_name", Value: options.Prefix, DataType: "string"},
		{Name: "existing_secrets_manager_instance_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
		{Name: "service_credential_secrets", Value: serviceCredentialSecrets, DataType: "list(object)"},
		{Name: "service_credential_names", Value: string(serviceCredentialNamesJSON), DataType: "map(string)"},
	}
	err = options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunStandardUpgradeSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       standardSolutionTerraformDir,
		BestRegionYAMLPath: regionSelectionPath,
		Prefix:             "rabbitmq-st-da-upg",
		ResourceGroup:      resourceGroup,
	})

	options.TerraformVars = map[string]interface{}{
		"access_tags":               permanentResources["accessTags"],
		"existing_kms_instance_crn": permanentResources["hpcs_south_crn"],
		"kms_endpoint_type":         "public",
		"provider_visibility":       "public",
		"resource_group_name":       options.Prefix,
		"admin_pass":                GetRandomAdminPassword(t),
	}

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestPlanValidation(t *testing.T) {
	t.Parallel()

	options := &terraform.Options{
		TerraformDir: "../" + standardSolutionTerraformDir,
		Vars: map[string]interface{}{
			"prefix":              "validate-plan",
			"region":              "us-south",
			"kms_endpoint_type":   "public",
			"provider_visibility": "public",
			"resource_group_name": "validate-plan",
			"admin_pass":          GetRandomAdminPassword(t),
		},
		Upgrade: true,
	}

	_, initErr := terraform.InitE(t, options)
	assert.Nil(t, initErr, "This should not have errored")

	// Test the DA when using IBM owned encryption keys
	options.Vars["use_default_backup_encryption_key"] = false
	options.Vars["use_ibm_owned_encryption_key"] = true
	output, err := terraform.PlanE(t, options)
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")

	// Test the DA when using Default Backup Encryption Key and not IBM owned encryption keys
	options.Vars["existing_kms_instance_crn"] = permanentResources["hpcs_south_crn"]
	options.Vars["use_default_backup_encryption_key"] = true
	options.Vars["use_ibm_owned_encryption_key"] = false
	output, err = terraform.PlanE(t, options)
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func GetRandomAdminPassword(t *testing.T) string {
	// Generate a 15 char long random string for the admin_pass
	randomBytes := make([]byte, 13)
	_, randErr := rand.Read(randomBytes)
	require.Nil(t, randErr) // do not proceed if we can't gen a random password

	randomPass := "A1" + base64.URLEncoding.EncodeToString(randomBytes)[:13]

	return randomPass
}
