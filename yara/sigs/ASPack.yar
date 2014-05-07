rule mp_strings
{
 meta:
  author = "@botnet_hunter"
  date = "2014-03-13"
  description = "Identify Madness Pro"
 strings:
  $c = "YXBvS0FMaXBsaXM9"
  $str5 = "d3Rm" fullword
  $str6 = "ZXhl" fullword
 condition:
  all of them
}