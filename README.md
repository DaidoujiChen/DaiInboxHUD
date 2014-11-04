DaiInboxHUD
===========

這是一個模仿 google inbox 轉圈效果的 HUD.

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiInboxHUD_20141104.gif)

DaidoujiChen

daidoujichen@gmail.com

總覽
===========
長久以來我就蠻想要一個自己做的 HUD 用, 前幾天幸運的從 g+ 善心人士 [宇治松千夜](https://plus.google.com/u/0/+%E6%88%B4%E6%B5%B7%E5%88%9A%E4%B8%AD%E5%9B%BD/auto) 這邊拿到了一組 inbox 邀請碼, 裝了 app 之後覺得他裡面的轉圈效果很棒, 所以花了幾天的時間, 儘量的模仿了他的效果, 未來可以給自己的其他專案使用, 由於是燒燙燙的專案, 所以它的功能目前還很貧乏, 只有 show / hide 兩個而已...再來會慢慢的再把功能加進去, 希望大家可以喜歡這個效果.

簡易使用
===========
先把 `DaiInboxHUD` 資料夾下的東西 copy 一份到你想用他的專案中, 然後在想使用他的地方先

	#import "DaiInboxHUD.h"
	
然後就算是可以使用了, 當要叫 HUD 出來的時候 call

	[DaiInboxHUD showHUD];
	
要他消失的時候 call

	[DaiInboxHUD hideHUD];
	
就沒了...囧rz, 非常的貧乏. 過一陣子比較多功能實現出來也比較健全的時候, 再來看怎麼樣讓他變成用 cocoapod 裝吧.