fs = require 'fs'
path = require 'path'
{CompositeDisposable} = require 'atom'

class Flatwhite

  config: require('./flatwhite-settings').config

  activate: ->

    @disposables = new CompositeDisposable
    @packageName = require('../package.json').name
    @disposables.add atom.config.observe "#{@packageName}.ebmedded", => @enableConfigTheme()

  deactivate: ->
    @disposables.dispose()

  enableConfigTheme: ->
    ebmedded = atom.config.get "#{@packageName}.ebmedded"
    @enableTheme ebmedded

  enableTheme: (ebmedded) ->
    embedded_path = "#{__dirname}/../styles/settings.less"
    fs.writeFileSync embedded_path, "@import 'languages/embedded-#{@getNormalizedName(ebmedded)}';"
    atom.packages.getLoadedPackage("#{@packageName}").reloadStylesheets()

  getNormalizedName: (name) ->
    "#{name}"
      .replace /\ /g, '-'
      .toLowerCase()

module.exports = new Flatwhite
