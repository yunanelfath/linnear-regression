# tugas machine learning email to yosi@stts.edu
# [Tugas machine learning 1]
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
        title: text: 'Scatter plot with regression line'
        legend:
          # layout: 'vertical',
          align: 'right',
          verticalAlign: 'middle'
          floating: true,
          # backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
          borderWidth: 1
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
            # marker: enabled: false
            scatter: lineWidth: 2
            states: hover: lineWidth: 0
            # enableMouseTracking: false
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
    ret = parseFloat(@state.form.teta0) + parseFloat(@state.form.teta1) * parseFloat(x)
    ret

  onProcess: () ->
    { form, scatters } = @state
    { iteration, alpha, teta0, teta1 } = form

    @onChangeForm('numberIteration', 0) # reset number iteration
    tempTeta0 = 0
    tempTeta1 = 0
    targetIteration = parseFloat(iteration)
    myLoop = () =>
      setTimeout (() =>
        total0 = 0
        total1 = 0
        i=0
        while i < scatters.length
          x = parseFloat(scatters[i][0])
          y = parseFloat(scatters[i][1])
          total0 += @_calculateHipotesa(x) - y
          total1 += (@_calculateHipotesa(x) - y) * x
          i++

        total0 = total0 / scatters.length
        total1 = total1 / scatters.length
        tempTeta0 = parseFloat(@state.form.teta0) - parseFloat(alpha) * total0
        tempTeta1 = parseFloat(@state.form.teta1) - parseFloat(alpha) * total1

        @onChangeForm('teta0', tempTeta0)
        @onChangeForm('teta1', tempTeta1)


        i = 0
        regressions = []
        # more looping for drawing graph
        while i < scatters.length
          x = parseFloat(scatters[i][0])
          y = parseFloat(scatters[i][1])
          regression = @_calculateHipotesa(x)
          # console.log 'ini adalah '+regression+','+y+','+x
          if(typeof scatters[i+1] != 'undefined')
            for k in _.range(x+1, scatters[i+1][0])
              regression2 = @_calculateHipotesa(k)
              regressions.push [k, regression2]
              k++
          regressions.push [x, regression]
          i++


        @onChangeForm('regressions', regressions)

        @state.chartData.series[1].update(
          data: regressions
        )

        console.log @state.form.numberIteration

        @state.form.numberIteration++
        @onChangeForm('numberIteration', @state.form.numberIteration)
        if(@state.form.numberIteration < targetIteration)
          myLoop()
      ), 100

    myLoop()


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
          <FormControl value={form?.iteration} type="text" onChange={onChangeForm.bind(null, 'iteration')} placeholder="iteration"/>
        </FormGroup>
        <FormGroup>
          teta0
          <FormControl value={form?.teta0} type="text" onChange={onChangeForm.bind(@, 'teta0')} placeholder="teta0"/>
        </FormGroup>
        <FormGroup>
          teta1
          <FormControl value={form?.teta1} type="text" onChange={onChangeForm.bind(@, 'teta1')} placeholder="teta1"/>
        </FormGroup>
        <FormGroup>Iteration Number: {form?.numberIteration}</FormGroup>
        <Button onClick={onProcess}>Process</Button>
      </FormGroup>
      <div id="chart-container"></div>
    </div>

window.GradientDescent = GradientDescent;
