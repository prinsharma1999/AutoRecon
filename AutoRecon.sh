#!/bin/bash


echo Please input the domain you would like to scan:
read domain

subdomainEnum(){
	mkdir -p $domain $domain/subs $domain/recon
	subfinder -d $domain -o $domain/subs/SubfinderResults.txt
	amass enum -d  $domain -o $domain/subs/amassResults.txt
	cat $domain/subs/*.txt > $domain/subs/allSubsFound.txt
}
subdomainEnum

subdomainValidation(){
	cat $domain/subs/allSubsFound.txt |httprobe > $domain/subs/Httprobe.txt
}
subdomainValidation

nucleiScan(){
	nuclei -l $domain/subs/Httprobe.txt -t cves -c 100 -o $domain/recon/CVEs.txt
	nuclei -l $domain/subs/Httprobe.txt -t vulnerabilities -c 100 -o $domain/recon/Vulners.txt
	nuclei -l $domain/subs/Httprobe.txt -t security-misconfiguration -c 100 -o $domain/recon/Misconfig.txt
	nuclei -l $domain/subs/Httprobe.txt -t default-credentials -c 100 -o $domain/recon/DefaultCreds.txt
	nuclei -l $domain/subs/Httprobe.txt -t files -c 100 -o $domain/recon/Files.txt
	nuclei -l $domain/subs/Httprobe.txt -t subdomain-takeover -c 100 -o $domain/recon/SubsTakeover.txt
	nuclei -l $domain/subs/Httprobe.txt -t generic-detections -c 100 -o $domain/recon/Generic.txt
}
nucleiScan