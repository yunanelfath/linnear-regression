{ PropTypes } = React
{ Row, Col, FormGroup, Button, FormInput, FormControl } = ReactBootstrap


GradientDescent = React.createClass
  # propTypes:
  #   id: PropTypes.number.isRequired
  #
  getInitialState: ->
    {
      newObject: GlobalStore.newObject
    }
  #
  componentDidMount: ->
    @listener = GlobalStore.addChangeListener(@_onChange)
    @_highchartLoader();

  _highchartLoader: () ->
    # debugger
    Highcharts.chart $(ReactDOM.findDOMNode(@)).find('#chart-container')[0],
    xAxis:
      min: -0.5
      max: 5.5
    yAxis: min: 0
    title: text: 'Scatter plot with regression line'
    series: [
      {
        type: 'line'
        name: 'Regression Line'
        data: [
          [
            0
            1.11
          ]
          [
            5
            4.51
          ]
        ]
        marker: enabled: false
        states: hover: lineWidth: 0
        enableMouseTracking: false
      }
      {
        type: 'scatter'
        name: 'Data'
        data: [
          [
            1
            1.5
          ]
          [
            2.8
            3.5
          ]
          [
            3.9
            4.2
          ]
        ]
        marker: radius: 4
      }
    ]
  #
  componentWillUnmount: ->
    @listener.remove()
    @_highchartLoader.remove

  _onChange: ->
    @setState(
      newObject: GlobalStore.newObject
    )

  dispatchEvent: (attributes, actionType, assign) ->
    dispatcher.dispatch(
      actionType: if actionType then actionType else 'attributes-setter'
      attributes: attributes
      # assign: id: @props.id, type: if assign then assign else null
    )

  onChangeForm: (id, event) ->
    params = {}
    params[id] = if event?.target then event.target.value else event
    @dispatchEvent(params, 'parent-attributes-setter')


  render: ()->
    <div>
      <FormGroup>
        <FormGroup>
          <FormControl placeholder="alpha"/>
        </FormGroup>
        <FormGroup>
          <FormControl placeholder="iteration"/>
        </FormGroup>
        <FormGroup>
          <FormControl placeholder="teta0"/>
        </FormGroup>
        <FormGroup>
          <FormControl placeholder="teta1"/>
        </FormGroup>
        <Button>Process</Button>
      </FormGroup>
      <div id="chart-container"></div>
    </div>

window.GradientDescent = GradientDescent;
