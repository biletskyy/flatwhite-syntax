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
