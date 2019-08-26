# Nagios Plugins for UPS monitor with **SNMP**.

Pack files for monitor most importants caracteristcs in a UPS sistem.

## Documentation


### Dependency
You need ruby instaled and snmp gem instaled.

### Install

Clone project in folder where you want use.

git clone https://github.com/adrianocortes/nagios_ups.git

### For instructions use
```shell 
ruby <script_name> -help
```

### Get time remaining for use in battery
Obs.: The value returned independent if are using battery
```ruby
 check_ups_minutes_remaining.rb -H XXX.XXX.XXX.XXX -C "public" -c 10 -w 20
 ```
 Alert with WARN status if less than 20 minutes and alert with CRITICAL if less than 10 minutes



## Product Versions

V.0.1
______



## License Information

This product is open source!

All code is released under the MIT License. Details in LICENCE file.
