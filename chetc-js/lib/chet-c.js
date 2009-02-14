function Epigraph2Markup(replacements) {
	this.replacementStr = replacements;
	this.ignoreLB = false;
	//alert("calling init()");
	this.init();
}

Epigraph2Markup.prototype.init = function() {
  var unicodeLetters = '[\u0041-\u005a\u0061-\u007a\u00aa\u00b5\u00ba\u00c0-\u00d6\u00d8-\u00f6\u00f8-\u01ba\u01bc-\u01bf \u01c4-\u02ad\u0386\u0388-\u0481\u048c-\u0556\u0561-\u0587\u10a0-\u10c5\u1e00-\u1fbc\u1fbe\u1fc2-\u1fcc \u1fd0-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ffc\u207f\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126 \u2128\u212a-\u212d\u212f-\u2131\u2133\u2134\u2139\ufb00-\ufb17\uff21-\uff3a\uff41-\uff5a]';
	this.replacements = new Array();
	lines = this.replacementStr.split(/\r?\n/);
	for (i=0; i < lines.length; i++) {
		line = lines[i];
		if (line.charAt(0) != '#' && !line.match(/^\s*$/)) {
			if (!(this.ignoreLB && line.match(/^\\n/))) {
				repl = line.split(/\s+=\s+/);
				if (repl.length == 2) {
				  repl[0] = repl[0].replace(/\\w/g, unicodeLetters);
				  if (repl[1] == 'null') {
				    repl[1] = '';
				  }
					this.replacements.push(repl);
				}
			}
		}
	}
}

Epigraph2Markup.prototype.lineBreaks = function(ignore) {
	if (ignore == 'true') {
		this.ignoreLB = true;
	} else {
		this.ignoreLB = false;
	}
}

Epigraph2Markup.prototype.count = function(txt, find) {
	if (txt == find) {
		result = txt.replace(/\s/g, '').length;
	} else {
		result = 0;
		compare = txt;
		while (compare.indexOf(find) >= 0) {
			result++;
			compare = compare.substr(compare.indexOf(find) + find.length);
		}
	}
	return result;
}

Epigraph2Markup.prototype.convert = function(text) {
	var result = text;
	for (i = 0; i < this.replacements.length; i++) {
		var repl = this.replacements[i];
		var replace = repl[1];
		if (replace.match(/%g/)) {
			var pattern = new RegExp(repl[0]);
			while (matches = result.match(pattern)) {
				var g = 0;
				var len = 0;
				var re = /%g(\d)/;
				if (captured = re.exec(replace)) {
					g = captured[1];
					replace = replace.replace(/%g\d/g, "");
					re = /%len(\d)/;
					if (captured = re.exec(replace)) {
						len = captured[1];
						replace = replace.replace(/%len\d/g, this.count(matches[g], matches[len]));
						result = result.replace(pattern, replace);
					}
				}
				replace = repl[1];
			}
		} else {
			var pattern = new RegExp(repl[0], "g");
			result = result.replace(pattern, replace);
		}
		while (ids = result.match(/id="%mkID(\d)"/)) {
			var id = new String(Math.random());
			id = 'id' + id.substr(2,5);
			var idPattern = new RegExp('(id=")%mkID'+ids[1]+'(")');
			result = result.replace(idPattern, "$1"+id+"$2");
			if (replace.match(/target="%mkID\d"/)) {
				var targPattern = new RegExp('(target=")%mkID'+ids[1]+'(")');
				result = result.replace(targPattern, "$1"+id+"$2");
			}
		}
	}
	return result;
}
