// @flow
import "phoenix_html"
import React from "react"
import ReactDOM from "react-dom"
import {Socket} from "phoenix"

alert('hello')

const COLORS = [
'c4e899',
'95d7a4',
'69b18f',
'307e80',
'034262',
'ff7575',
'ff8775',
'ffba79',
'ffcb71',
'292e32',
'cccccc',
'7aa0c4',
'34568f',
'2f425e',
'f0f7ce',
'bbeaaa',
'9fdda5',
'f59ba5',
'f87d92',
]

const randColor = () => COLORS[Math.floor(Math.random()*COLORS.length)]
const randIndex = () => Math.floor(Math.random() * 25)

type Props = {
}

type State = {
  image: Array<string>
}

class App extends React.Component<Props, State> {
  constructor(props) {
    super(props)

    this.color = randColor()
    document.querySelector('body').style.background = '#' + this.color + 'ee'

    this.cardRefs = []

    this.state = {
      cards: []
    }

  }

  componentDidMount() {
    const socket = new Socket("/socket", {params: {}})
    socket.connect()
    this.channel = socket.channel("demo:hello", {})

    this.channel.join()
      .receive("ok", (res) => {
        console.log('joined!', res)
      })
      .receive("error", (res) => {
        console.log('error joining', res)
      })

    this.channel.on("cards:state", ({ data }) => {
      this.setState({ cards: data })
    })

    this.channel.on("cards:change", ({ index, color }) => {
      const cards = this.state.cards
      cards[index] = color
      this.setState({ cards })

      if (this.color !== color) {
        this.cardRefs[index].checked = !this.cardRefs[index].checked
      }
    })
  }

  handleClick(e, index) {
    if (e.target.type === 'checkbox') {
      this.channel.push("cards:change", { index, color: this.color })
    }
  }

  render() {
    const cards = this.state.cards.map((color, i) => {
      return (
        <Card
          key={i}
          color={color}
          refn={(c) => this.cardRefs[i] = c }
          onClick={(e) => this.handleClick(e, i)} />
      )
    })

    return (
      <div className="App">
        <div className="--cards">
          { cards }
        </div>
      </div>
    )
  }
}

const Card = (props: { reffn: *, colors: [string, string], onClick: * }) => {
  return (
    <label className="Card" onClick={props.onClick}>
      <input type="checkbox" ref={props.refn}/>
      <div className="--sides">
        <div className="--front" style={{ background: `#${props.color}` }} />
        <div className="--back" style={{ background: `#${props.color}` }} />
      </div>
    </label>
  )
};

ReactDOM.render(<App />, document.getElementById('root'))

window.makeRobot = () => {
  const socket = new Socket("/socket", {params: {}})
  socket.connect()
  const channel = socket.channel("demo:hello", {})
  channel.join()
  const color = randColor()
  setInterval(() => {
    channel.push("cards:change", { index: randIndex(), color })
  }, 1000);
}
