
$VARIANTS = @(
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @()
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
        }
        # Docker image tag
        tag = 'v1.5.3153.0'
        tag_as_latest = $true
    }
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @( 'bf2hub' )
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
        }
        # Docker image tag
        tag = 'v1.5.3153.0-bf2hub'
        tag_as_latest = $true
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
