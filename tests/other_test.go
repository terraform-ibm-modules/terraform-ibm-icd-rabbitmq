// Tests in this file are run in the PR pipeline
package test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       "examples/basic",
		Prefix:             "rabbitmq-basic",
		ResourceGroup:      resourceGroup,
		BestRegionYAMLPath: regionSelectionPath,
		CloudInfoService:   sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func testPlanICDVersions(t *testing.T, version string) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/basic",
		TerraformVars: map[string]interface{}{
			"rabbitmq_version": version,
		},
		CloudInfoService: sharedInfoSvc,
	})
	output, err := options.RunTestPlan()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestPlanICDVersions(t *testing.T) {
	t.Parallel()

	// This test will run a terraform plan on available stable versions of rabbitmq
	versions, _ := sharedInfoSvc.GetAvailableIcdVersions("rabbitmq")
	for _, version := range versions {
		t.Run(version, func(t *testing.T) { testPlanICDVersions(t, version) })
	}
}

func TestRunRestoredDBExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/backup-restore",
		Prefix:        "rabbitmq-restored",
		ResourceGroup: resourceGroup,
		Region:        fmt.Sprint(permanentResources["rabbitmqRegion"]),
		TerraformVars: map[string]interface{}{
			"rabbitmq_db_crn": permanentResources["rabbitmqCrn"],
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunFSCloudExample(t *testing.T) {
	t.Parallel()
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/fscloud",
		Prefix:       "rabbitmq-cmp",
		Region:       "us-south", // For FSCloud locking into us-south since that is where the HPCS permanent instance is
		/*
		 Comment out the 'ResourceGroup' input to force this test to create a unique resource group to ensure tests do
		 not clash. This is due to the fact that an auth policy may already exist in this resource group since we are
		 re-using a permanent HPCS instance. By using a new resource group, the auth policy will not already exist
		 since this module scopes auth policies by resource group.
		*/
		//ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"access_tags":      permanentResources["accessTags"],
			"kms_key_crn":      permanentResources["hpcs_south_root_key_crn"],
			"rabbitmq_version": "3.13", // Always lock this test into the latest supported RabbitMQ version
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
