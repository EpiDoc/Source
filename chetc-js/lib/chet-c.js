function Epigraph2Markup(replacements) {
	this.replacementStr = replacements;
	this.ignoreLB = false;
	//alert("calling init()");
	this.init();
}

Epigraph2Markup.prototype.init = function() {
	this.replacements = new Array();
	lines = this.replacementStr.split("\n");
	for (i=0; i < lines.length; i++) {
		line = lines[i];
		if (line.charAt(0) != '#' && !line.match(/^\s*$/)) {
			if (!(this.ignoreLB && line.match(/^\\n/))) {
				repl = line.split(/\s+=\s+/);
				if (repl.length == 2) {
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
		result = txt.length;
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
		if (replace.match(/%len/)) {
			var pattern = new RegExp(repl[0]);
			while (matches = result.match(pattern)) {
				var g = 0;
				var len = 0;
				var re = /%g(\d+)/;
				if (captured = re.exec(replace)) {
					g = captured[1];
					replace = replace.replace(/%g\d+/g, "");
					re = /%len(\d+)/;
					if (captured = re.exec(replace)) {
						len = captured[1];
						replace = replace.replace(/%len\d+/g, this.count(matches[g], matches[len]));
						result = result.replace(pattern, replace);
					}
				}
				replace = repl[1];
			}
		} else {
			var pattern = new RegExp(repl[0], "g");
			result = result.replace(pattern, replace);
		}
	}
	return result;
}
