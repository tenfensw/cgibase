# cgibase.applescript
# CGI library for AppleScript, I guess
# Currently mostly contains query string parsing functions
# 
# Copyright (C) Tim K 2019-2020 <timprogrammer@rambler.ru>
#
# Requires Mac OS X 10.6 or newer

on splitString(qs, sep)
	set resultat to {}
	set tmpData to ""
	repeat with itm in (characters in qs)
		set realCharacter to (itm as string)
		if realCharacter is equal to sep then
			set end of resultat to tmpData
			set tmpData to ""
		else
			set tmpData to (tmpData) & realCharacter
		end if
	end repeat
	if (length of tmpData) is greater than 0 then
		set end of resultat to tmpData
	end if
	return resultat
end splitString

on parseQueryString()
	set contentsv to (system attribute "QUERY_STRING")
	set resultat to {}
	set splitContents to splitString(contentsv, "&")
	repeat with pair in splitContents
		set splitPair to splitString(pair, "=")
		if (length of splitPair) is greater than 1 then
			set hashmapv to {key:((item 1 of splitPair) as string), value:((item 2 of splitPair) as string)}
			set end of resultat to hashmapv
		end if
	end repeat
	return resultat
end parseQueryString

on findInQueryString(qs, keyvv)
	repeat with subpair in qs
		if ((key of subpair) as string) is equal to keyvv then
			return (value of subpair)
		end if
	end repeat
	return {}
end findInQueryString

on dump(listing)
	set output to ""
	set firstrun to true
	repeat with linev in listing
		if firstrun then
			set firstrun to false
			set output to (linev as string)
		else
			set output to (output) & (ASCII character 13) & (ASCII character 10) & (linev as string)
		end if
	end repeat
	copy output to stdout
	return output
end dump

on respond(listingOfRecords)
	set resultat to {}
	repeat with itm in listingOfRecords
		if (class of itm) is record then
			set end of resultat to ((key of itm) & ": " & (value of itm))
		else
			set end of resultat to ""
			set end of resultat to (itm as string)
			exit repeat
		end if
	end repeat
	dump(resultat)
end respond

on r(txt, mimetype)
	respond({{key:"Content-type", value:mimetype}, txt})
end r
