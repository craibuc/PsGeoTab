function Remove-GeotabEntity {

    [CmdletBinding(SupportsShouldProcess)]
    param (
		[Parameter(Mandatory)]
		[PsCustomObject]$Session,

        [Parameter(Mandatory)]
		[string]$typeName,

        [Parameter(Mandatory)]
        [object]$entity
    )
    
    begin {
        $Uri = "https://$($Session.path)/apiv1"
        Write-Debug "Uri: $Uri"
    }
    
    process {
        # payload        
        $Body = @{
            method = 'Remove'
            params = @{ 
                credentials = $Session.credentials
                typeName = $typeName
                entity = $entity
            }
        }
        
        # payload as JSON
        Write-Debug ($Body | ConvertTo-Json -Depth 4)
    
        # POST
        if ( $PSCmdlet.ShouldProcess("Invoke-WebRequest") )
        {
            $Content = ( Invoke-WebRequest -Uri $uri -Method Post -Body ($Body | ConvertTo-Json -Depth 4) -ContentType "application/json" ).Content | ConvertFrom-Json

            # returns PsCustomObject representation of object
            if ( $Content.result ) { $Content.result }

            # otherwise raise an exception
            elseif ($Content.error) { Write-Error -Message $Content.error.message }
        }

    }
    
    end {}

}