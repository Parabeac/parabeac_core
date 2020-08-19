## Version 0.5.0, 2018.11.23

* moved from !ninja to neocotic [ad5aa55](https://github.com/neocotic/convert-svg/commit/ad5aa559daa04a4276fc025e0a37d0d9768eab28)
* modified CI to now target Node.js 8, 10, and 11 [63fcb27](https://github.com/neocotic/convert-svg/commit/63fcb2702cba03ec12f7998c0c0ee0b84b862986)
* bump dependencies [6daedb1](https://github.com/neocotic/convert-svg/commit/6daedb1d27f56455d7797628bbff90aa59597565)
* bumped devDependenices [3a8ae85](https://github.com/neocotic/convert-svg/commit/3a8ae8528939819a90f2754adacc82864475d967)
* fixed linting errors [96e7e06](https://github.com/neocotic/convert-svg/commit/96e7e061abb75b83b92ca675f2d1bb68e76f28ae)
* fixed broken tests by regenerating expected fixtures [bf34770](https://github.com/neocotic/convert-svg/commit/bf34770a5707903849cd8005a7b82d735ee3c281)
* preventing lerna breaking build when calling "npm ci" on bootstrap [1391071](https://github.com/neocotic/convert-svg/commit/1391071f57550d2b9b9ded5dca84776d3ce11fa7)
* skipped tests that were causing CI build to fail intermittently [cdf43c0](https://github.com/neocotic/convert-svg/commit/cdf43c06079e498354c4e8299f784dc290a11461)

## Version 0.4.0, 2018.02.05

* Bump Puppeteer to v1 [#32](https://github.com/neocotic/convert-svg/issues/32)
* Replace chai with assert [#34](https://github.com/neocotic/convert-svg/issues/34)

## Version 0.3.3, 2017.12.08

* Add puppeteer.launch options available into CLI [#29](https://github.com/neocotic/convert-svg/issues/29)

## Version 0.3.2, 2017.11.21

* Error being thrown caused by lost context for CLI [#24](https://github.com/neocotic/convert-svg/issues/24)
* Pass custom arguments to puppeteer [#25](https://github.com/neocotic/convert-svg/issues/25) [#27](https://github.com/neocotic/convert-svg/issues/27)
* Bump puppeteer to v0.13.0 [#26](https://github.com/neocotic/convert-svg/issues/26)

## Version 0.3.1, 2017.11.03

* Error thrown as context is lost for API methods when using destructuring imports [#22](https://github.com/neocotic/convert-svg/issues/22)

## Version 0.3.0, 2017.11.03

* Add option to control background color [#14](https://github.com/neocotic/convert-svg/issues/14)
* Remove all controllable short options for CLI [#15](https://github.com/neocotic/convert-svg/issues/15) (**breaking change**)
* Split package up into multiple packages to be more modular [#17](https://github.com/neocotic/convert-svg/issues/17) (**breaking change**)
* Add convert-svg-to-jpeg package to convert SVG to JPEG [#18](https://github.com/neocotic/convert-svg/issues/18)

## Version 0.2.0, 2017.10.29

* Add CLI & convertFile method to API [#2](https://github.com/neocotic/convert-svg/issues/2) [#8](https://github.com/neocotic/convert-svg/issues/8)
* Add scale option [#3](https://github.com/neocotic/convert-svg/issues/3) [#11](https://github.com/neocotic/convert-svg/issues/11)
* Throw error when baseFile & baseUrl options are both specified [#4](https://github.com/neocotic/convert-svg/issues/4) (**breaking change**)
* Change source/target terminology to input/output [#6](https://github.com/neocotic/convert-svg/issues/6)
* Expose Converter class as primary export [#9](https://github.com/neocotic/convert-svg/issues/9) (**breaking change**)

## Version 0.1.0, 2017.10.19

* Initial release
