class Chapter {
    
    constructor() {
        
        this.parser = 'book_hzh\\(\\);</script>((?!</p>).*)</p></div></div>.+<a href="([^"]+)" hidefocus="[^"]+">上一章</a>.+<a href="([^"]+)" hidefocus="[^"]+">下一章</a></div>';
    }
    
    crawl(str) {
        
        var regexp = new RegExp(this.parser, 'g');
        var result = '';
        while (result = regexp.exec(str)) {
            for (const iterator of result) {
                console.log(iterator);
            }
        }
    }
}

function download(url) {
    
    var xhr = new XMLHttpRequest()
    
    xhr.onreadystatechange = function() {
        
        console.log('' + xhr.readyState);
        
        if (xhr.readyState != 4) {
            return;
        }
        
        if (xhr.status != 200) {
            console.log('网络错误:(' + xhr.statusText + ')[' + xhr.status + ']');
            return;
        }
                        
        let html = xhr.responseText;
        
        let exp1 = new RegExp("([\r\n\t]|amp;)+", 'g');
        let ret1 = html.replace(exp1, '');
        
        let exp2 = new RegExp("\s{2,}|&nbsp;", 'g');
        let ret2 = ret1.replace(exp2, ' ');
        
        let exp3 = new RegExp("\\s+>", 'g');
        let ret3 = ret2.replace(exp3, ">");

        let exp4 = new RegExp("(<br />|<br/>)+", 'g');
        let ret4 = ret3.replace(exp4, "<br>");  

        var chapter = new Chapter();
        chapter.crawl(ret4);
    }
    
    xhr.open("GET", url, true);
    xhr.overrideMimeType("text/csv;charset=gb2312");
    xhr.send();
}

function objectBySwift(method, url, body) {

    var xhr = new XMLHttpRequest()

    xhr.onreadystatechange = function() {

        console.log('' + xhr.readyState);
        
        if (xhr.readyState != 4) {
            return;
        }

        if (xhr.status != 200) {
            console.log('网络错误:(' + xhr.statusText + ')[' + xhr.status + ']');
            return;
        }
        
        console.log(xhr.responseText);
        
        var json = null;

        try {
            json = eval('(' + xhr.responseText + ')');
        }
        catch (err) {
            console.log('xxxxx' + err.message);
            return;
        }

        console.log(json["require"]["phpmailer/phpmailer"]);
        
        testexp()
    }

    if (method == 'GET') {
        xhr.open("GET", url, true);
        xhr.send();
    } else {
        // xhr.open(method, url, true);
        // xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        // xhr.send(JSON.stringify(body));
    }
}

function testexp() {
    
    var str = '<dd><a href="15991282.html">37．击杀狗头人</a></dd><dd><a href="15991283.html">38．迷宫</a></dd><dd><a href="15991284.html">39．才不是故意占便宜！</a></dd><dd><a href="15991285.html">40．劳资就是拽劳资就是酷炫</a></dd>';
    var reg = '<dd><a href="([^"]+)">([^<]+)</a></dd>';
    
    // // 使用match进行搜索, 带g参数, 不再有圆括号匹配的子字符串了
    // var regexp = new RegExp(reg, 'g');
    // var match = str.match(regexp);
    // console.log(match);
    
    // 使用match进行搜索, 没有g参数
    var regexp = new RegExp(reg);
    var match = '';
    var seastr = str;
    while (match = seastr.match(regexp)) {
        console.log(match);
        for (const iterator of match) {
            console.log(iterator);
        }
        seastr = seastr.substring(match.index + match[0].length);
    }
    
    // // 使用exec进行搜索, 带g参数
    // var regexp = new RegExp(reg, 'g');
    // var match = '';
    // while (match = regexp.exec(str)) {
    //     console.log(match);
    //     for (const iterator of match) {
    //         console.log(iterator);
    //     }
    // }
    
    // // 使用exec进行搜索, 没有g参数
    // var regexp = new RegExp(reg);
    // var match = '';
    // var seastr = str;
    // while (match = regexp.exec(seastr)) {
    //     console.log(match);
    //     for (const iterator of match) {
    //         console.log(iterator);
    //     }
    //     seastr = seastr.substring(match.index + match[0].length);
    // }
}


