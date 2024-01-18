const express = require("express");

const app = express();
const bodyParser = require("body-parser");

const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const mysql = require("mysql");

const cors = require("cors");

var PythonShell = require("python-shell").PythonShell;

const secret = "StppVIotSUUvipwf29zthUCTLWJHQXuz"; // key for generating JSON web tokens

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "major_project",
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

app.get("/kmeans", (req, res) => {
  let options = {
    mode: "text",
    pythonPath: "python",
    scriptPath: "C:/Users/fernn/Desktop/Major Project/Backend/Kmeans",
    args: [
      "2,3,3,2,2,5",
      "2,3,4,5,5,5",
      "4,5,2,5,5,3",
      "5,2,5,5,5,4",
      "5,3,4,5,2,5",
    ],
  };

  PythonShell.run("test.py", options, function (err, results) {
    if (err) throw err;
    // results is an array consisting of messages collected during execution
    // console.log("results: %j", results);
    res.status(200).json({ cluster: Number(results[0][1]) });
  });
});

app.post("/kmeans", (req, res) => {
  const { data, user_id } = req.body;
  console.log(req.body);
  console.log(data);
  console.log(user_id);

  flat_arr = [];
  const allEqual4 = (arr) => arr.every((val) => val === arr[0]);

  for (let i = 0; i < data.length; i++) {
    splt = data[i].split(",");
    for (let j = 0; j < splt.length; j++) flat_arr.push(splt[j]);
  }

  if (allEqual4(flat_arr)) {
    connection.query(
      `DELETE FROM users WHERE user_id=${Number(user_id)}`,
      function (error, result) {
        if (error) throw error;
      }
    );

    return res.status(401).json({
      success: false,
      message: "potential fake user",
      fakeUser: Number(1),
      distance: Number(3.552122623350298),
      user_id: user_id,
    });
  }

  let options = {
    mode: "text",
    pythonPath: "python",
    scriptPath: "C:/Users/fernn/Desktop/Major Project/Backend/Kmeans",
    args: data,
  };

  PythonShell.run("test.py", options, function (err, results) {
    if (err) {
      return res.status(401).json({ message: err });
    }
    if (results[1] == 0) {
      connection.query(
        "UPDATE users SET cluster = ?, fake_user = ?, distance_center = ? WHERE user_id = ?",
        [
          Number(results[0][1]),
          Number(results[1]),
          Number(results[2]),
          Number(user_id),
        ],
        function (error, results) {
          if (error) {
            return res.status(401).json({ message: error });
          }
        }
      );

      data_str = "";
      for (let i = 0; i < data.length; i++) {
        data_str += data[i];
        data_str += ",";
      }

      data_str = data_str.slice(0, data_str.length - 1);

      connection.query(
        `UPDATE users SET data_str = "${data_str}" where user_id = ${Number(
          user_id
        )}`,
        function (error, results) {
          if (error) throw error;
        }
      );

      res.status(200).json({
        success: true,
        cluster: Number(results[0][1]),
        fakeUser: Number(results[1]),
        distance: Number(results[2]),
        user_id: user_id,
      });
    } else {
      connection.query(
        `DELETE FROM users WHERE user_id=${Number(user_id)}`,
        function (error, result) {
          if (error) throw error;
        }
      );

      return res.status(401).json({
        success: false,
        message: "potential fake user",
        fakeUser: Number(results[1]),
        distance: Number(results[2]),
        user_id: user_id,
      });
    }
  });
});

app.post("/kmeans-test", (req, res) => {
  const { data } = req.body;
  console.log(req.body);
  console.log(data);
  flat_arr = [];
  const allEqual4 = (arr) => arr.every((val) => val === arr[0]);
  for (let i = 0; i < data.length; i++) {
    splt = data[i].split(",");
    for (let j = 0; j < splt.length; j++) flat_arr.push(splt[j]);
  }

  if (allEqual4(flat_arr)) {
    return res.status(401).json({
      success: false,
      message: "potential fake user",
      fakeUser: Number(1),
      distance: Number(3.552122623350298),
    });
  }

  let options = {
    mode: "text",
    pythonPath: "python",
    scriptPath: "C:/Users/fernn/Desktop/Major Project/Backend/Kmeans",
    args: data,
  };

  PythonShell.run("test.py", options, function (err, results) {
    if (err) {
      return res.status(401).json({ message: err });
    }
    if (results[1] == 0) {
      res.status(200).json({
        success: true,
        cluster: Number(results[0][1]),
        fakeUser: Number(results[1]),
        distance: Number(results[2]),
      });
    } else {
      return res.status(401).json({
        success: false,
        message: "potential fake user",
        fakeUser: Number(results[1]),
        distance: Number(results[2]),
      });
    }
  });
});

app.get("/hello", (req, res) => {
  return res.json({ message: "hello" });
});

app.post("/auth/login", (req, res) => {
  const { email, password } = req.body;

  connection.query(
    `SELECT * FROM users WHERE email = '${email}'`,
    function (error, results) {
      if (error) {
        // throw error;
        return res
          .status(401)
          .json({ message: "Invalid username or password." });
      }

      if (results.length === 0) {
        return res
          .status(401)
          .json({ message: "Invalid username or password." });
      } else {
        // Compare the hashed password
        const compare = bcrypt.compareSync(password, results[0].password);
        if (compare) {
          // generate a JSON web token and return it to the client
          // const token = jwt.sign({ userId: results[0].id }, secret, {
          //   expiresIn: "1h",
          // });
          return res.status(200).json({
            success: true,
            user_id: results[0]["user_id"],
            email: results[0]["email"],
            cluster: results[0]["cluster"],
          });
        } else {
          return res
            .status(401)
            .json({ message: "Invalid username or password." });
        }
      }
    }
  );
});

app.post("/auth/signup", (req, res) => {
  let {
    email,
    name,
    password,
    type,
    location,
    likes,
    dislikes,
    bio,
    image_url,
  } = req.body;
  likes = likes.toString();
  likes = likes.slice(1, likes.length - 1);
  likes = likes.replace(/\"/gi, "");

  dislikes = dislikes.toString();
  dislikes = dislikes.slice(1, dislikes.length - 1);
  dislikes = dislikes.replace(/\"/gi, "");

  connection.query(
    `SELECT * FROM users WHERE email = '${email}'`,
    function (error, results) {
      if (error) {
        return res.status(401).json({ message: "Something went wrong." });
      }

      if (results.length > 0) {
        return res.status(409).json({ message: "Email already registered." });
      } else {
        // Hash the password
        const salt = bcrypt.genSaltSync(10);
        const hashedPassword = bcrypt.hashSync(password, salt);
        if (image_url == "") {
          connection.query(
            `INSERT INTO users (email, name, password, type, bio, likes, dislikes, location) VALUES ('${email}','${name}','${hashedPassword}','${type}','${bio}','${likes}','${dislikes}','${location}')`,
            function (error, results) {
              if (error) throw error;
              // generate a JSON web token and return it to the client
              // const token = jwt.sign({ userId: results.insertId }, secret, {
              //   expiresIn: "1h",
              // });
              return res
                .status(200)
                .json({ success: true, user_id: results["insertId"] });
            }
          );
        }
        // insert the new user into the database
        else
          connection.query(
            `INSERT INTO users (email, name, password, type, bio, likes, dislikes, location, image_url) VALUES ('${email}','${name}','${hashedPassword}','${type}','${bio}','${likes}','${dislikes}','${location}','${image_url}')`,
            function (error, results) {
              if (error) throw error;
              // generate a JSON web token and return it to the client
              // const token = jwt.sign({ userId: results.insertId }, secret, {
              //   expiresIn: "1h",
              // });
              return res
                .status(200)
                .json({ success: true, user_id: results["insertId"] });
            }
          );
      }
    }
  );
});

app.post("/matches", (req, res) => {
  const { id, cluster } = req.body;

  connection.query(
    `SELECT type,location FROM users WHERE user_id = ${id}`,
    function (err, res0) {
      if (err) throw err;
      var loc = res0[0]["location"];
      console.log(loc);
      if (res0[0]["type"] == "Homeowner") {
        connection.query(
          `SELECT * FROM users WHERE cluster = ${cluster} and type = 'Tenant' and location = '${loc}' and user_id not in (select matched_id from matches where user_id = ${id}) and user_id != ${id} `,
          function (error, results) {
            if (error) throw error;

            connection.query(
              `SELECT * from users where user_id=${id}`,
              function (err, res1) {
                if (err) throw err;

                let user_data = res1[0]["data_str"];
                user_data = user_data.split(",");

                for (let i = 0; i < results.length; i++) {
                  let cluster_user = results[i]["data_str"];
                  cluster_user = cluster_user.split(",");
                  let count = 0;
                  for (let j = 0; j < 30; j++) {
                    if (
                      Number(user_data[j]) > 3 &&
                      Number(cluster_user[j]) > 3
                    ) {
                      count += 1;
                    } else if (
                      Number(user_data[j]) < 3 &&
                      Number(cluster_user[j]) < 3
                    ) {
                      count += 1;
                    } else if (
                      Number(user_data[j]) == 3 &&
                      Number(cluster_user[j]) == 3
                    )
                      count += 1;
                  }

                  results[i]["similarity"] = ((count / 30) * 100).toFixed(2);

                  // console.log(`similarity: ${((count / 30) * 100).toFixed(2)}`);
                }

                var sorted = results.sort(function onSimilarity(a, b) {
                  return parseFloat(b.similarity) < parseFloat(a.similarity)
                    ? -1
                    : parseFloat(b.similarity) > parseFloat(a.similarity)
                    ? 1
                    : 0;
                });

                return res.status(200).json(sorted);
              }
            );

            // console.log(results);
          }
        );
      } else {
        connection.query(
          `SELECT * FROM users WHERE cluster = ${cluster} and type = 'Homeowner' and location = '${loc}' and user_id not in (select matched_id from matches where user_id = ${id}) and user_id != ${id} `,
          function (error, results) {
            if (error) throw error;
            connection.query(
              `SELECT * from users where user_id=${id}`,
              function (err, res1) {
                if (err) throw err;
                let user_data = res1[0]["data_str"];
                user_data = user_data.split(",");
                for (let i = 0; i < results.length; i++) {
                  let cluster_user = results[i]["data_str"];
                  cluster_user = cluster_user.split(",");
                  let count = 0;
                  for (let j = 0; j < 30; j++) {
                    if (
                      Number(user_data[j]) > 3 &&
                      Number(cluster_user[j]) > 3
                    ) {
                      count += 1;
                    } else if (
                      Number(user_data[j]) < 3 &&
                      Number(cluster_user[j]) < 3
                    ) {
                      count += 1;
                    } else if (
                      Number(user_data[j]) == 3 &&
                      Number(cluster_user[j]) == 3
                    )
                      count += 1;
                  }
                  results[i]["similarity"] = ((count / 30) * 100).toFixed(2);
                  // console.log(`similarity: ${((count / 30) * 100).toFixed(2)}`);
                }
                var sorted = results.sort(function onSimilarity(a, b) {
                  return parseFloat(b.similarity) < parseFloat(a.similarity)
                    ? -1
                    : parseFloat(b.similarity) > parseFloat(a.similarity)
                    ? 1
                    : 0;
                });
                return res.status(200).json(sorted);
              }
            );
            // console.log(results);
          }
        );
      }
    }
  );
});

app.post("/match", (req, res) => {
  const { id, match_id } = req.body;

  connection.query(
    `SELECT data_str from users where user_id = ${id}`,
    function (err, res1) {
      if (err) throw err;

      connection.query(
        `SELECT data_str from users where user_id = ${match_id}`,
        function (err, res2) {
          if (err) throw err;

          let a = res1[0]["data_str"].split(",");
          let b = res2[0]["data_str"].split(",");
          let count = 0;

          for (let i = 0; i < a.length; i++) {
            if (a[i] === b[i]) {
              count += 1;
            }
          }

          let similarity = ((count / 30) * 100).toFixed(2);

          connection.query(
            `INSERT INTO matches (user_id, matched_id, similarity) VALUES (${id},${match_id},${similarity});`,
            function (error, results) {
              if (error) throw error;
              // console.log(results);
            }
          );

          connection.query(
            `INSERT INTO matches (user_id, matched_id, similarity) VALUES (${match_id},${id},${similarity});`,
            function (error, results) {
              if (error) throw error;

              return res.status(200).json({ message: "ok" });
              // console.log(results);
            }
          );
        }
      );
    }
  );
});

app.post("/get-chats", (req, res) => {
  const { user_id } = req.body;

  let text = `select * from users where user_id in (Select matched_id from matches where user_id = ${user_id})`;
  connection.query(
    `select * from users inner join matches on users.user_id = matches.matched_id where matches.user_id = ${user_id}`,
    function (error, results) {
      if (error) throw error;

      return res.status(200).json(results);
      // console.log(results);
    }
  );
});

app.post("/ig-profile", (req, res) => {
  const { userID } = req.body;

  let options = {
    mode: "text",
    pythonPath: "python",
    scriptPath:
      "C:/Users/fernn/Desktop/Major Project/Backend/Instagram Profile",
    args: userID,
  };

  PythonShell.run("profile-picker.py", options, function (err, results) {
    if (err) {
      console.log(err);
      return res.status(401).json({ message: "server declined." });
    }

    return res.json({ url: results[0] });
  });
});

app.post("/chats", (req, res) => {
  const { user1_id, user2_id } = req.body;

  connection.query(
    `SELECT * FROM chats where (user1_id = ${user1_id} or user1_id = ${user2_id}) and (user2_id = ${user2_id} or user2_id = ${user1_id})`,
    function (error, result) {
      if (error) throw error;

      if (result.length > 0) {
        res.status(200).json(result.reverse());
      } else {
        res.status(404).json({ message: "notfound" });
      }
    }
  );
});

app.post("/submit-chat", (req, res) => {
  const { user1_id, user2_id, message } = req.body;

  connection.query(
    `INSERT INTO chats(user1_id, user2_id, message) VALUES (${user1_id},${user2_id},'${message}')`,
    function (error, result) {
      if (error) throw error;

      return res.status(200).json({ message: "ok" });
    }
  );
});

app.post("/user-status", (req, res) => {
  const { user_id } = req.body;

  connection.query(
    `SELECT type from users WHERE user_id = ${user_id}`,
    function (error, result) {
      if (error) throw error;

      return res.status(200).json([{ type: result[0]["type"] }]);
    }
  );
});

app.post("/reject", (req, res) => {
  const { user1_id, user2_id } = req.body;

  connection.query(
    `UPDATE matches set accepted = 0 where user_id = ${user1_id} and matched_id = ${user2_id}`,
    function (error, result) {
      if (error) throw error;
    }
  );

  connection.query(
    `UPDATE matches set accepted = 0 where user_id = ${user2_id} and matched_id = ${user1_id}`,
    function (error, result) {
      if (error) throw error;
    }
  );

  return res.status(200).json({ success: true });
});

app.post("/rejected-status", (req, res) => {
  const { user_id, matched_id } = req.body;

  connection.query(
    `SELECT accepted from matches where user_id = ${user_id} and matched_id = ${matched_id}`,
    function (err, res1) {
      if (err) throw err;

      return res.json(res1);
    }
  );
});

app.post("/accept", (req, res) => {
  const { user1_id, user2_id } = req.body;

  connection.query(
    `UPDATE matches set accepted = 1 where user_id = ${user1_id} and matched_id = ${user2_id}`,
    function (error, result) {
      if (error) throw error;
    }
  );

  connection.query(
    `UPDATE matches set accepted = 1 where user_id = ${user2_id} and matched_id = ${user1_id}`,
    function (error, result) {
      if (error) throw error;
    }
  );

  return res.status(200).json({ success: true });
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
