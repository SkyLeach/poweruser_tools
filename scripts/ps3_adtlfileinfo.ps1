if ( $host.Version.Major -gt "3" ) {
    Update-TypeData -TypeName System.IO.FileInfo -MemberName FileSize -MemberType ScriptProperty -Value { 

        switch($this.length) {
                   { $_ -gt 1tb } 
                          { "{0:n2} TB" -f ($_ / 1tb) }
                   { $_ -gt 1gb } 
                          { "{0:n2} GB" -f ($_ / 1gb) }
                   { $_ -gt 1mb } 
                          { "{0:n2} MB " -f ($_ / 1mb) }
                   { $_ -gt 1kb } 
                          { "{0:n2} KB " -f ($_ / 1Kb) }
                   default  
                          { "{0} B " -f $_} 
                 }      

     } -DefaultDisplayPropertySet Mode,LastWriteTime,FileSize,Name
 }
