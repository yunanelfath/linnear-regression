{ PropTypes } = React
{ Row, Col, FormGroup, Button, FormInput, FormControl } = ReactBootstrap


GradientDescent = React.createClass
  propTypes:
    scatters: PropTypes.array
  #
  getInitialState: ->
    {
      form: GlobalStore.form
      scatters: @props.scatters
      chartData: null
    }
  #
  componentDidMount: ->
    @listener = GlobalStore.addChangeListener(@_onChange)
    @_highchartLoader();

  _highchartLoader: () ->
    # debugger
    chartData = Highcharts.chart $(ReactDOM.findDOMNode(@)).find('#chart-container')[0],
        xAxis:
          min: 135
          # max: 5.5
        # yAxis: min: 0
        title: text: 'Scatter plot with regression line'
        series: [
          {
            type: 'scatter'
            name: 'Data'
            color: 'rgba(223, 83, 83, .5)',
            data: @state.scatters
          }
          {
            type: 'line'
            name: 'Regression Line'
            data: @state.form.regressions
            marker: enabled: false
            states: hover: lineWidth: 0
            enableMouseTracking: false
          }
        ]

      @setState(chartData: chartData)
  #
  componentWillUnmount: ->
    @listener.remove()
    @_highchartLoader.remove

  _onChange: ->
    @setState(
      form: GlobalStore.form
    )

  dispatchEvent: (attributes, actionType, assign) ->
    dispatcher.dispatch(
      actionType: if actionType then actionType else 'attributes-setter'
      attributes: attributes
    )

  onChangeForm: (id, event) ->
    params = {}
    params[id] = if event?.target then event.target.value else event
    @dispatchEvent(params, 'parent-attributes-setter')
    console.log(@state.form[id])

  _calculateHipotesa: (x) ->
    # console.log('teat0 ||'+@state.form.teta0+" teta1||"+@state.form.teta1+" ||"+x)
    ret = (parseFloat(@state.form.teta0) + parseFloat(@state.form.teta1)) * parseFloat(x)
    ret

  onProcess: () ->
    { form, scatters } = @state
    { iteration, alpha, teta0, teta1, finalTeta0, finalTeta1 } = form

    tempTeta0 = 0
    tempTeta1 = 0
    numberIteration = 0
    targetIteration = parseFloat(iteration)
    console.log('start iterartion'+numberIteration)
    myLoop = () =>
      setTimeout (() =>
        # loop
        # regression code
        # debugger
        # console.log('loop awal total ||'+scatters.length+" ||teta0"+@state.form.teta1+" teta1||"+@state.form.teta0+"|| number iteration"+numberIteration)
        total = 0
        i=0
        while i < scatters.length
          x = scatters[i][0]
          y = scatters[i][1]
          # if x == 147.2
            # debugger
          total += @_calculateHipotesa(x) - y
          i++
        # total = (total / scatters.length)
        tempTeta0 = parseFloat(@state.form.teta0) - parseFloat(alpha) * total / scatters.length
        # console.log('disini '+@state.form.teta0)

        # debugger
        total = 0
        i=0
        while i < scatters.length
          x = scatters[i][0]
          y = scatters[i][1]
          # if x == 147.2
            # debugger
          total = total + ((@_calculateHipotesa(x) - y) * x)
          i++
        # total = (total / scatters.length)
        tempTeta1 = parseFloat(@state.form.teta1) - parseFloat(alpha) * total / scatters.length
        # console.log('neng kene'+ @state.form.teta1)

        # debugger

        # finalTeta0 = tempTeta0
        # finalTeta1 = tempTeta1
        # console.log('neng kene belum berubah semua'+ @state.form.teta1+" "+@state.form.teta0)
        @onChangeForm('teta0', tempTeta0)
        @onChangeForm('teta1', tempTeta1)
        # console.log('semua udah berubah'+ @state.form.teta1+" "+@state.form.teta0)

        arrayX = @state.scatters.map (e) ->
            e[0]
        minOfy = Math.min.apply(Math, arrayX)
        maxOfy = Math.max.apply(Math, arrayX)
        regressions = [
          [minOfy, tempTeta0]
          [maxOfy, tempTeta1]
        ]

        @onChangeForm('regressions', regressions)

        # console.log(regressions[0][0]+","+regressions[0][1]+"|||"+regressions[1][0]+","+regressions[1][1])
        @state.chartData.series[1].update(
          data: regressions
        )
        # if numberIteration >= targetIteration
          # break

        console.log numberIteration
        numberIteration++
        if(numberIteration <= targetIteration)
          # debugger
          myLoop()

        # debugger
      ), 300

    myLoop()

    console.log(@state.form.regressions)


  render: ()->
    {onChangeForm, onProcess} = @
    { form } = @state
    # { alpha, teta0, teta1, iteration } = form
    <div>
      <FormGroup>
        <FormGroup>
          alpha
          <FormControl value={form?.alpha} type="text" onChange={onChangeForm.bind(@, 'alpha')} placeholder="alpha"/>
        </FormGroup>
        <FormGroup>
          iteration
          <FormControl type="text" onChange={onChangeForm.bind(null, 'iteration')} placeholder="iteration"/>
        </FormGroup>
        <FormGroup>
          teta0
          <FormControl value={form?.teta0} type="text" onChange={onChangeForm.bind(@, 'teta0')} placeholder="teta0"/>
        </FormGroup>
        <FormGroup>
          teta1
          <FormControl value={form?.teta1} type="text" onChange={onChangeForm.bind(@, 'teta1')} placeholder="teta1"/>
        </FormGroup>
        <Button onClick={onProcess}>Process</Button>
      </FormGroup>
      <div id="chart-container"></div>
    </div>

window.GradientDescent = GradientDescent;
