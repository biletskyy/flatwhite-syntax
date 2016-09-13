settings =
  config:
    ebmedded:
      title: 'HTML embedded highlighting variant'
      description: 'Chose between simple (default) and full highlighting  variants'
      type: 'string'
      default: 'Simple'
      enum: ["Simple", "Full"]
module.exports = settings
