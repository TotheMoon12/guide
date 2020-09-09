const express = require('express')
const http = require('http')
var fs = require('fs');
const bodyParser = require('body-parser')
const cors = require('cors')
const morgan = require('morgan')
var path = require('path')

var network = require('./fabric/network.js');
// var fabcar = require('./fabric/fabcar.js');

const app = express()
app.use(morgan('combined'))
app.use(bodyParser.json())
app.use(cors())
app.use(express.static(path.join(__dirname,'/')));
var server = http.createServer(app);
var io = require('socket.io')(server);
server.listen(10023, '165.229.185.73');

app.get('/', function(req,res) {
  res.sendFile(__dirname + '/login/Login_v8/login.html');
})

app.post('/', function(req,res) {
  res.sendFile(__dirname + '/login/Login_v8/login.html');
})

app.get('/register', function(req,res) {
  res.sendFile(__dirname + '/register/register.html');
})

app.post('/register', function(req,res) {
  res.sendFile(__dirname + '/register/register.html');
})

app.get('/home', function(req, res){
  res.sendFile(__dirname + '/home/home.html');
});

app.get('/progress', function(rea, res){
  res.sendFile(__dirname + '/home/progress.html');
});

app.get('/end', function(rea, res){
  res.sendFile(__dirname + '/home/end.html');
});

app.get('/voteroom', function(req, res){
  res.sendFile(__dirname + '/vote/voteroom.html');
});

app.get('/voteresult', function(req, res){
  res.sendFile(__dirname + '/vote/voteresult.html');
});

io.on('connect', function(socket){
  console.log('Client Connect');

  socket.on('register', function(name, ssn, Username, password){
    console.log("register Start");
    network.registerUser(name, Username, password, ssn).then((response)=>{
      socket.emit(name, response.toString());
    })
  });
  
  socket.on('login', function(Username, password) {
    network.login(Username,password).then((response) => {
      socket.emit(Username,response.toString());
    })
  }) 

  socket.on('disconnect', function(){
      console.log('Client disconnect');
  });
  
  socket.on('progress', function() {
    console.log("progress connect")
    network.queryProgressList().then((response) => {
      console.log("progress")
      console.log(response);
      socket.emit('progress-reply',response.toString());
      console.log("end");
   })
  });

  socket.on('end', function() {
    console.log("end connect")
    network.queryEndList().then((response) => {
      console.log(response.toString());
      socket.emit('end-reply',response.toString());
      console.log("end");
   })
  });

  socket.on('voteroom', function(msg){
    console.log('voteroom connect')
    network.queryAllCandidate(msg).then((response) => {
      socket.emit(msg,JSON.parse(response));
    })

    let reply = msg+'reply';

    network.queryCurrentSituation(msg).then((situationres)=> {
      // console.log(JSON.parse(res));
        socket.emit(reply,JSON.parse(situationres));
      })

    // network.queryCurrentSituation(msg).then((res)=> {
    //   socket.emit(reply,JSON.parse(res));
    // })

  socket.on('vote', function(id, symbol, name, belong, code, title){
    console.log("vote start");
    network.createVote(id, symbol, name, belong, code, title).then((voteres) => {
      network.queryCurrentSituation(msg).then((situationres)=> {
        // console.log(JSON.parse(res));
          socket.emit(reply,JSON.parse(situationres));
        })
    })
  })
  })

  socket.on('voteresult', function(msg){
    console.log('voteresult connect')
    network.queryAllCandidate(msg).then((response) => {
      socket.emit(msg, JSON.parse(response));
    })

    let reply = msg+'reply';

    network.queryCurrentSituation(msg).then((situationres)=> {
        console.log(JSON.parse(situationres));
        socket.emit(reply,JSON.parse(situationres));
      })

    // network.queryCurrentSituation(msg).then((res)=> {
    //   socket.emit(reply,JSON.parse(res));
    // })

  // socket.on('vote', function(id, symbol, name, belong, code, title){
  //   console.log("vote start");
  //   network.createVote(id, symbol, name, belong, code, title).then((voteres) => {
  //     network.queryCurrentSituation(msg).then((situationres)=> {
  //       // console.log(JSON.parse(res));
  //         socket.emit(reply,JSON.parse(situationres));
  //       })
  //   })
  // })
  })
});

app.get('/queryAllData', (req, res) => {
  network.queryAllData()
    .then((response) => {      
        let carsRecord = JSON.parse(response);
        console.log("그냥쿼리결과날립니다. :" + JSON.stringify(carsRecord));
        res.send(carsRecord)
      });
})

app.get('/queryProgressList',(req,res) => {
  network.queryProgressList().then((response) => {
    res.send(response);
  })
})

app.get('/queryEndList',(req,res) => {
  network.queryEndList().then((response) => {
    console.log(JSON.stringify(response))
    // res.send(response);
  })
})

const candidate = [
  {
      Symbol: 1,
      Name: 'PWG',
      Belong: 'AISL',
  },
  {
      Symbol: 2,
      Name: 'KTH',
      Belong: 'AISL',
  },
  {
      Symbol: 3,
      Name: 'SMW',
      Belong: 'AISL',
  },
  {
      Symbol: 4,
      Name: 'Jerry',
      Belong: 'AISL',
  },
  {
      Symbol: 5,
      Name: 'KJH',
      Belong: 'NONE',
  }
]
var candidateList = JSON.stringify(candidate);
var end = (new Date('06/04/2020 20:40:00').getTime()).toString();

network.createNewVotingroom('bye',candidateList,end)
.then((response) => {
  console.log("###########################")
  console.log("###########################")
  console.log("###########################")
  console.log(" ")
  console.log(" ")
  console.log(`끝난것 습니다`);
  console.log(`끝난것 습니다`);
  console.log(" ")
  console.log(" ")
  console.log("###########################")
  console.log("###########################")
  console.log("###########################")
})

end = (new Date('06/08/2020 20:40:00').getTime()).toString();

// network.createNewVotingroom('hello',candidateList,end)
// .then((response) => {
//   console.log("###########################")
//   console.log("###########################")
//   console.log("###########################")
//   console.log(" ")
//   console.log(" ")
//   console.log(`끝난것 습니다`);
//   console.log(`끝난것 습니다`);
//   console.log(" ")
//   console.log(" ")
//   console.log("###########################")
//   console.log("###########################")
//   console.log("###########################")
// })