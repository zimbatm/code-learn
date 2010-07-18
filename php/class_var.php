<?php

class Config {
  static $data = array();
}

Config::$data["foo"] = "bar";

var_dump(Config::$data);
