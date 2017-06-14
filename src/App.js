import React, { Component } from 'react';
import './App.css';

class App extends Component {

  // Initialize the state
  constructor(props) {
    super(props);

    // Binds
    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);

    // Store the messagesRef
    this.messagesRef = this.firebase.database().ref().child('messages');

    this.state = {
      messages: {},
      fetch: false,
      currentMessage: '',
      color: this.getRandomColor()
    }
  }

  get firebase() {
    return this.props.firebase;
  }

  get messages() {
    let messages = [];

    Object.keys(this.state.messages).forEach(key => {
      messages.push({
        key,
        value: this.state.messages[key].value,
        color: this.state.messages[key].color
      });
    }, this);

    return messages.reverse();
  }

  componentDidMount() {
    this.messagesRef.on('value', snapshot => {
      if (snapshot.val() !== null) {
        this.setState({
          messages: snapshot.val(),
          fetch: true
        });
      } else {
        this.setState({ fetch: true });
      }
    });
  }

  onChange(e) {
    e.preventDefault();
    this.setState({
      currentMessage: e.target.value
    });
  }

  onSubmit(e) {
    e.preventDefault();
    if (this.state.currentMessage.length > 0) {
      let newRef = this.messagesRef.push();
      newRef.set({
        value: this.state.currentMessage,
        color: this.state.color
      });
      this.setState({
        currentMessage: ''
      });
    }
  }

  getRandomColor() {
    let letters = '0123456789ABCDEF',
      color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

  renderMessages() {
    if (this.messages.length === 0 && this.state.fetch === false) {
      return <p className="lh-copy f5 black-70 tc">
        Loading messages...
      </p>
    } else if (this.messages.length === 0) {
      return <p className="lh-copy f5 black-70 tc">
        Messages will appear here :)
      </p>
    } else {
      return this.messages.map(message =>
        <article className="mw7 center bg-white mb3 pv1 ph3 mv3"
          key={ message.key } style={ { borderColor: message.color } }>
          <p className="lh-copy f5 black-70">
            { message.value }
          </p>
        </article>
      );
    }
  }

  render() {
    return (
      <div className="mw7 center ph2">
        <header className="mv5">
          <h1 className="tc f2 black-70">Rock the Open Source!</h1>
          <form onSubmit={ this.onSubmit }>
            <input className="input-reset ba b--black-20 pa2 mb2 db w-100 border-box"
              value={ this.state.currentMessage } onChange={ this.onChange }
              placeholder="Say hello!" />
          </form>
        </header>
        <div className="mb5">
          { this.renderMessages() }
        </div>
      </div>
    );
  }
}

export default App;
