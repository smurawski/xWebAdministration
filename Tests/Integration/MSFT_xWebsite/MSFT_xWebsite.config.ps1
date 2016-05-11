configuration MSFT_xWebsite_Config
{
    Import-DscResource -ModuleName xWebAdministration

    $WebsiteDirectory = "c:\Website"
    
    WindowsFeature 'WebServer'
    {
        Name = 'web-server'
    }

    file 'WebsiteDirectory'
    {
        DestinationPath = $WebsiteDirectory
        Type = 'Directory'
    }
    
    file 'WebsiteContent'
    {
        DependsOn = '[file]WebsiteDirectory'
        DestinationPath = Join-Path $WebsiteDirectory "index.html"
        Contents = 'Hey!'
    }
    
    xWebsite DefaultWebsite
    {
        Name = 'Default Web Site'
        State = 'Stopped'
        DependsOn = '[windowsfeature]WebServer'
    }

    xWebsite WebSite
    {
        Name = 'foobar'
        Ensure = 'Present'
        State = 'Started'
        PhysicalPath = $WebsiteDirectory
        DependsOn = '[file]WebsiteDirectory', '[xWebsite]DefaultWebsite'
    }
}
