describe 'Server is a Webserver' {
  context 'Features' {
    $Installed =  'Web-Server',
                  'Web-WebServer',
                  'Web-Common-Http',
                  'Web-Default-Doc',
                  'Web-Dir-Browsing',
                  'Web-Http-Errors',
                  'Web-Static-Content',
                  'Web-Health',
                  'Web-Http-Logging',
                  'Web-Performance',
                  'Web-Stat-Compression',
                  'Web-Dyn-Compression',
                  'Web-Security',
                  'Web-Filtering',
                  'Web-App-Dev',
                  'Web-Net-Ext45',
                  'Web-Asp-Net45',
                  'Web-ISAPI-Ext',
                  'Web-ISAPI-Filter',
                  'Web-Mgmt-Tools',
                  'Web-Mgmt-Service'

    $NotInstalled = 'Web-Application-Proxy',
                    'Web-Http-Redirect',
                    'Web-DAV-Publishing',
                    'Web-Custom-Logging',
                    'Web-Log-Libraries',
                    'Web-ODBC-Logging',
                    'Web-Request-Monitor',
                    'Web-Http-Tracing',
                    'Web-Basic-Auth',
                    'Web-CertProvider',
                    'Web-Client-Auth',
                    'Web-Digest-Auth',
                    'Web-Cert-Auth',
                    'Web-IP-Security',
                    'Web-Url-Auth',
                    'Web-Windows-Auth',
                    'Web-Net-Ext',
                    'Web-AppInit',
                    'Web-ASP',
                    'Web-Asp-Net',
                    'Web-CGI',
                    'Web-Includes',
                    'Web-WebSockets',
                    'Web-Ftp-Server',
                    'Web-Ftp-Service',
                    'Web-Ftp-Ext',
                    'Web-Mgmt-Console',
                    'Web-Mgmt-Compat',
                    'Web-Metabase',
                    'Web-Lgcy-Mgmt-Console',
                    'Web-Lgcy-Scripting',
                    'Web-WMI',
                    'Web-Scripting-Tools',
                    'Web-WHC'

    $CurrentWebFeatures = get-windowsfeature web* |
      where Installed |
      select -expand Name

    foreach ($feature in $CurrentWebFeatures)  {
      it "has $feature installed" {
        $installed -contains $feature | should be $true
      }
    }
    foreach ($feature in $NotInstalled)  {
      it "does not have $feature installed" {
        $CurrentWebFeatures -notcontains $feature | should be $true
      }
    }
  }
}

describe 'Behavior' {
    it 'has a website listening on port 80' {
      get-website | where {
          $_.state -like 'Started' -and
          $_.bindings.collection.bindinginformation -like '*:80:'
        } |
        should not benullorempty
    }

    it 'Returns "Hey!" on port 80' {
        irm 'http://localhost' | should match 'Hey!'
    }

    context 'WebRequest' {
        $webresponse = Invoke-WebRequest http://localhost -UseBasicParsing
        it 'returns 200' {
            $webresponse.statuscode | should be 200
        }
        
        it 'has a content length of 7' {
            $webresponse.rawcontentlength | should be 7
        }
    }
}