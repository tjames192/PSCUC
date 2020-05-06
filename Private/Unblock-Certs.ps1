function Unblock-Certs {
	# Hack for allowing untrusted SSL certs with https connections
	add-type @"
	using System.Net;
	using System.Security.Cryptography.X509Certificates;
	public class TrustAllCertsPolicy : ICertificatePolicy {
		public bool CheckValidationResult(
				ServicePoint srvPoint, X509Certificate certificate,
				WebRequest request, int certificateProblem) {
					return true;
				}
		}
"@
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

	[Net.ServicePointManager]::SecurityProtocol = 
	[Net.SecurityProtocolType]::Ssl3,
	[Net.SecurityProtocolType]::Tls,
	[Net.SecurityProtocolType]::Tls11,
	[Net.SecurityProtocolType]::Tls12
}