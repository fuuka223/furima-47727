const pay = () => {
  // フォームがあるか確認（なければ何もしない）
  const form = document.getElementById('charge-form');
  if (!form) return;
  // PAY.JPテスト公開鍵
const payjp = Payjp(gon.public_key);
  // 入力用エレメントの作成
  const elements = payjp.elements();
  // カード番号・有効期限・セキュリティコードの入力用エレメントの設定
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');
  // 2. マウント先の要素が存在するか念のため確認してから実行
  if (document.getElementById('number-form')) {
  // 各入力用エレメントにHTMLのIDを埋め込む
    numberElement.mount('#number-form');
    expiryElement.mount('#expiry-form');
    cvcElement.mount('#cvc-form');
  }
  // フォーム送信時のイベント
  form.addEventListener("submit", (e) => {
    // Railsの通常通信を一時停止
    e.preventDefault();
    // PAY.JPからトークンを発行
    payjp.createToken(numberElement).then(function (response) {
      // トークン発行成功時
      if (response.error) {
      } else {
        // トークンを代数に編入
        const token = response.id;
        // フォーム全体を取得
        const renderDom = document.getElementById("charge-form");
        // トークンを隠しパラメーターに生成
        const tokenObj = `<input value=${token} name='item_order[token]' type="hidden">`;
        // 隠しパラメーターをフォームの最後に挿入
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
      }
      // セキュリティのため、カード情報を削除
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();
      // ボタンを無効化
      document.getElementById("button").disabled = true;
      // フォーム送信
      document.getElementById("charge-form").submit();
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);