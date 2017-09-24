{ PropTypes } = React
GradientDescent = React.createClass
  # propTypes:
  #   id: PropTypes.number.isRequired
  #
  # getInitialState: ->
  #   {
  #     quickPollingEmbedEditor: GlobalStore.quickEmbedItems[@props.id]
  #   }
  #
  # componentDidMount: ->
  #   @listener = GlobalStore.addChangeListener(@_onChange)
  #
  # componentWillUnmount: ->
  #   @listener.remove()
  #
  # _onChange: ->
  #   @setState(
  #     quickPollingEmbedEditor: GlobalStore.quickEmbedItems[@props.id]
  #   )
  #
  # dispatchEvent: (attributes, actionType, assign) ->
  #   dispatcher.dispatch(
  #     actionType: if actionType then actionType else 'keepo-global-attributes-setter'
  #     attributes: attributes
  #     assign: id: @props.id, type: if assign then assign else null
  #   )

  render: ()->
    <div>test ini dari react looh wao wathcing you asdfasdf asdfasdf</div>

window.GradientDescent = GradientDescent;
