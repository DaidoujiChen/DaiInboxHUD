DaiInboxHUD
===========

這是一個模仿 google inbox 轉圈效果的 HUD.

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiInboxHUD_20141106.gif)

加入成功時候打勾的動畫

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiInboxHUDSuccess.gif)

失敗時候畫叉叉的動畫

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiInboxHUDFail.gif)

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

	[DaiInboxHUD show];
	
如果想要秀帶訊息的 hud 可以調用

	[DaiInboxHUD showMessage:[[NSAttributedString alloc] initWithString:@"Loading"]];
	
在這邊 message 的型別是 `NSAttributedString`, 這意味著你可以調整你想要的字型或是大小, 或是任何符合規定的效果, 比起 `NSString` 的話, 我認為靈活度會比較大,
	
要他消失的時候 call

	[DaiInboxHUD hide];

客製化
===========
如果你覺得內建的顏色很醜, 想要用自己調配的顏色, 或是想要跟自己的專案色調搭配一點的話, 這邊提供了幾種客製化的 method,

第一個是

	+ (void)setColors:(NSArray *)colors;

這個 method 可以幫助你改變循環的顏色, 內建本來是 紅 -> 綠 -> 黃 -> 藍 -> loop 這樣的循環, 起始顏色則為隨機, 如果想改變的話, 可以調用

	[DaiInboxHUD setColors:@[[UIColor grayColor], [UIColor whiteColor], [UIColor blackColor], [UIColor purpleColor]]];
	
以這個例子來說, 循環色將會被改變成 灰 -> 白 -> 黑 -> 紫 -> loop,

第二個是

	+ (void)setBackgroundColor:(UIColor *)backgroundColor;

這個 method 可以幫助你改變 hud 背後那一小塊的顏色, 系統預設為 0.65 alpha 的黑色, 是的, 請記得 `UIColor` 可以設 alpha, 有助於幫助在專案上的搭配, 可以調用

	[DaiInboxHUD setBackgroundColor:[UIColor colorWithRed:0.43f green:0.12f blue:0.95f alpha:0.4f]];
	
來做背景色的改變, 數字是我亂打的, 我也不知道出來會是什麼色,

第三個是

	+ (void)setLineWidth:(CGFloat)lineWidth;

顧名思義, 他就是用來改線條的粗細, 如果你覺得內建的線太細, 很容易折斷或是老人家看不清楚, 可以透過這個 method 來做改變, 預設的寬度只有 2.0f

	[DaiInboxHUD setLineWidth:10.0f];
	
改成 10.0f 的時候線會變得胖胖的, 很可愛, 但是再往上加畫出來的圖就會有些怪怪的了, 這邊可以自己斟酌微調,

第四個是

	+ (void)setMaskColor:(UIColor *)maskColor;

如果你希望 hud 跳出來的時候, 背後原來的畫面應該要覆蓋上一層薄膜, 可以利用這個 method 來達成, 預設是 clearColor, 所以背景不會被覆蓋, 如果想用一層黑色的膜蓋上, 可以像是這樣設定

	[DaiInboxHUD setMaskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
	
則會有一層 alpha 值 0.5 的黑膜蓋著, 記得一定要設 alpha, 不然背景會完全被蓋住,
	
需要注意的地方是, 假設專案裡面所有的 hud 都是通用同一種樣貌的話, 那麼只需要在統一的一個地方設定好客製化的值就可以了, 不需要在每次 `show` hud 時都設定一次, 不過如果專案需要各種不同的 hud 樣貌的時候, 則在每次 `show` 之前就得記得去改變成 for 某一個樣式的 hud.