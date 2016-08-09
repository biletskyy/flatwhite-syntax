clone: function (o) {
			var type = _.util.type(o);

			switch (type) {
				case 'Object':
					var clone = {};

					for (var key in o) {
						if (o.hasOwnProperty(key)) {
							clone[key] = _.util.clone(o[key]);
						}
					}

					return clone;

				case 'Array':
					// Check for existence for IE8
					return o.map && o.map(function(v) { return _.util.clone(v); });
			}

			return o;
		}
	},

StringStream.prototype = {
  done: function() {return this.pos >= this.string.length;},
  peek: function() {return this.string.charAt(this.pos);},
  next: function() {
    if (this.pos < this.string.length)
      return this.string.charAt(this.pos++);
  },
  eat: function(match) {
    var ch = this.string.charAt(this.pos);
    if (typeof match == "string") var ok = ch == match;
    else var ok = ch && match.test ? match.test(ch) : match(ch);
    if (ok) {this.pos++; return ch;}
  },
  eatWhile: function(match) {
    var start = this.pos;
    while (this.eat(match));
    if (this.pos > start) return this.string.slice(start, this.pos);
  },
  backUp: function(n) {this.pos -= n;},
  column: function() {return this.pos;},
  eatSpace: function() {
    var start = this.pos;
    while (/\s/.test(this.string.charAt(this.pos))) this.pos++;
    return this.pos - start;
  },
  match: function(pattern, consume, caseInsensitive) {
    if (typeof pattern == "string") {
      function cased(str) {return caseInsensitive ? str.toLowerCase() : str;}
      if (cased(this.string).indexOf(cased(pattern), this.pos) == this.pos) {
        if (consume !== false) this.pos += str.length;
        return true;
      }
    }
    else {
      var match = this.string.slice(this.pos).match(pattern);
      if (match && consume !== false) this.pos += match[0].length;
      return match;
    }
  }
};

/**
 * Loads plugins, then resources, and then starts the Aurelia instance.
 * @return Returns a Promise with the started Aurelia instance.
 */
start(): Promise<Aurelia> {
  if (this.started) {
    return Promise.resolve(this);
  }

  this.started = true;
  this.logger.info('Aurelia Starting');

  return this.use.apply().then(() => {
    preventActionlessFormSubmit();

    if (!this.container.hasResolver(BindingLanguage)) {
      let message = 'You must configure Aurelia with a BindingLanguage implementation.';
      this.logger.error(message);
      throw new Error(message);
    }

    this.logger.info('Aurelia Started');
    let evt = DOM.createCustomEvent('aurelia-started', { bubbles: true, cancelable: true });
    DOM.dispatchEvent(evt);
    return this;
  });
}

/**
 * Enhances the host's existing elements with behaviors and bindings.
 * @param bindingContext A binding context for the enhanced elements.
 * @param applicationHost The DOM object that Aurelia will enhance.
 * @return Returns a Promise for the current Aurelia instance.
 */
enhance(bindingContext: Object = {}, applicationHost: string | Element = null): Promise<Aurelia> {
  this._configureHost(applicationHost || DOM.querySelectorAll('body')[0]);

  return new Promise(resolve => {
    let engine = this.container.get(TemplatingEngine);
    this.root = engine.enhance({container: this.container, element: this.host, resources: this.resources, bindingContext: bindingContext});
    this.root.attached();
    this._onAureliaComposed();
    resolve(this);
  });
}
