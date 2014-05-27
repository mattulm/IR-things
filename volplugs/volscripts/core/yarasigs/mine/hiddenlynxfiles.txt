rule hiddenlynx_hacker_files {
	strings:
		$file1 = "vptray.exe" nocase ascii wide
		$file2 = "up.bak" nocase ascii wide
		$file3 = "kb1035627.dat" nocase ascii wide
		$file4 = "Temp\\uid.ax" nocase ascii wide
		$domain = "usc-data.suroot.com" fullword nocase ascii wide
		
	condition:
		1 of them
}

rule hiddenlynx_hikit {
	// http://www.symantec.com/security_response/writeup.jsp?docid=2012-082113-5541-99&tabid=2
	meta:
		author = "31ric"
		description = "Backdoor.Hikit is a Trojan horse that opens a back door on the compromised computer."

	strings: 
		$file1 = "w7fw.sys" nocase ascii wide
		$file2 = "w7fw_m.inf" nocase ascii wide
		$file3 = "w7fw.inf" nocase ascii wide
		$file4 = "w7fw.cat" nocase ascii wdie
		$file5 = "drivers\\W7fw.sys" nocase ascii wide
		
	condition:
		1 of them
}