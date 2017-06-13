const express = require('express'),
  app = express();

// Static files
app.use(express.static('build'));

// Port
const port = process.env.PORT || 3000;

// Always send the index.html file
app.get('*', (req, res) => {
  res.sendFile(__dirname + '/build/index.html');
});

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
