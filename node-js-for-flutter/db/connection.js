const mysql = require("mysql2");

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "i1kaigo9icu",
  database: "clothingstore",
});

module.exports = pool.promise();
