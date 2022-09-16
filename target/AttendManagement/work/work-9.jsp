<!-- 現場詳細ページ -->
<%
// ***************************************************
// work-9.jsp
// 対象月（指定月）の実績一覧を表示する
// ***************************************************
%>

<!DOCTYPE html>
<html lang="ja">
<head>

  <!-- Basic Page Needs
  -------------------------------------------------- -->
  <meta charset="utf-8">
  <title>警備業ポータルサイト</title>
  <meta name="description" content="">
  <meta name="format-detection" content="telephone=no">

  <!-- Mobile Specific Metas
  -------------------------------------------------- -->
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- CSS
  -------------------------------------------------- -->
  <!-- フォント読み込み -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
  <!-- bootstrap CSS読み込み -->
  <link href="./assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- スタイルシート読み込み -->
  <link rel="stylesheet" href="./assets/css/style.css">

  <!-- Favicon
  -------------------------------------------------- -->
  <link rel="icon" type="image/png" href="./assets/images/favicon.png">



</head>
<body>
  <!-- ヘッダー部 -->
  <header>
    <!-- 固定ヘッダー -->
    <section class="fixed above u-layer">
      <div class="row">
        <div class="nav-item"><a href="#" onclick="history.back(-1);return false;">＜戻る</a></div>
        <div class="nav-item">2022年07月19日(火)</div>
        <div class="nav-item">12:00</div>
      </div>
    </section>

    <!-- 固定フッター -->
    <section class="fixed bottom">
      <div class="row">
        <div class="ico mail">
          <button onclick="location.href='../news/news-1.html'">
            <img src="./assets/images/mail.png" alt="">
            <span class="num">123</span>
          </button>
        </div>
        <div class="ico">
          <button onclick="location.href='../top.html'">
            <img src="./assets/images/home.png" alt="">
          </button>
        </div>
        <div class="ico">
          <button onclick="location.href='#'">
            <img src="./assets/images/top-arrow.png" alt="">
          </button>
        </div>
      </div>
    </section>
  </header>
  <!-- ヘッダー部end -->

  <!-- メインコンテンツ -->
  <main class="p-work">
    <section class="inner">
      <!-- ページタイトル -->
      <h1 class="m-ttl">
        実績一覧
      </h1>
    </section>


    <section class="inner">

      <!-- 月選択 -->
      <div class="w-box mt-4">
        <select name="dt-num" id="dt-num">
          <option value="2022年9月" selected>2022年9月</option>
          <option value="2022年10月">2022年10月</option>
          <option value="2022年11月">2022年11月</option>
          <option value="2022年12月">2022年12月</option>
          <option value="2023年1月">2023年1月</option>
        </select>
      </div>
  

      <!-- カレンダー -->
      <div class="w-box cal mt-4">
        <div class="cal-month row mt-5">
          <span class="arrow"><button onclick="location.href=''">&#60;</button></span>
          <span class="ym"><h2>2022.9</h2></span>
          <span class="arrow r"><button onclick="location.href=''">&#62;</button></span>
        </div>
        <div class="cal-contents mt-3">
          <table>
            <tr>
              <th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th><th>日</th>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#1'"><span>1</button></span></td><td class="none"><button onclick="location.href='#2'"><span>2</button></span></td><td class="none"><button onclick="location.href='#3'"><span>3</button></span></td><td class="none"><button onclick="location.href='#4'"><span>4</button></span></td><td class="none"><button onclick="location.href='#5'"><span>5</button></span></td><td class="mor current"><button onclick="location.href='#6'"><span>6</span></button></td><td class="eve"><button onclick="location.href='#7'"><span>7</button></span></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#8'"><span>8</button></span></td><td class="se"><button onclick="location.href='#9'"><span>9</button></span></td><td class="mor"><button onclick="location.href='#10'"><span>10</span></button></td><td class="eve"><button onclick="location.href='#11'"><span>11</span></button></td><td class="mor"><button onclick="location.href='#12'"><span>12</span></button></td><td class="all"><button onclick="location.href='#13'"><span>13</span></button></td><td class="none"><button onclick="location.href='#14'"><span>14</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#15'"><span>15</span></button></td><td class="none"><button onclick="location.href='#16'"><span>16</span></button></td><td class="none"><button onclick="location.href='#17'"><span>17</span></button></td><td class="none"><button onclick="location.href='#18'"><span>18</span></button></td><td class="none"><button onclick="location.href='#19'"><span>19</span></button></td><td class="none"><button onclick="location.href='#20'"><span>20</span></button></td><td class="none"><button onclick="location.href='#21'"><span>21</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#22'"><span>22</span></button></td><td class="none"><button onclick="location.href='#23'"><span>23</span></button></td><td class="none"><button onclick="location.href='#24'"><span>24</span></button></td><td class="none"><button onclick="location.href='#25'"><span>25</span></button></td><td class="none"><button onclick="location.href='#26'"><span>26</span></button></td><td class="none"><button onclick="location.href='#27'"><span>27</span></button></td><td class="none"><button onclick="location.href='#28'"><span>28</span></button></td>
            </tr>
            <tr>
              <td class="none"><button onclick="location.href='#29'"><span>29</span></button></td><td class="none"><button onclick="location.href='#30'"><span>30</span></button></td><td class="none"><button onclick="location.href='#31'"><span>31</span></button></td><td class="none"><button onclick="location.href='#1'"><span>1</button></span></td><td class="none"><button onclick="location.href='#2'"><span>2</button></span></td><td class="none"><button onclick="location.href='#3'"><span>3</button></span></td><td class="none"><button onclick="location.href='#4'"><span>4</button></span></td>
            </tr>
          </table>
        </div>
      </div>
      
    </section>
    
  </main>
  <!-- メインコンテンツend -->

  <!-- フッター部 -->
  <footer>
    <ul>
      <li><button onclick="location.href='#'">使い方</button></li>
      <li><button onclick="location.href='#'">会社概要</button></li>
      <li><button onclick="location.href='#'">ログアウト</button></li>
    </ul>
  </footer>
  <!-- フッター部end -->



   <!-- Script
  -------------------------------------------------- -->
  <!-- Jquery読み込み -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <!-- bootstrap JS読み込み -->
  <script src="./assets/bootstrap/js/bootstrap.min.js"></script>
  
</body>
</html>