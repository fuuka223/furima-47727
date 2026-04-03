const priceInput = () => {
  // 販売価格の入力フォームの取得
  const priceInput = document.getElementById("item-price")
  // 入力された際のイベント
  priceInput.addEventListener("input", () => {
    // 入力された値を変数に代入
    const inputValue = priceInput.value;
      // ---販売手数料の計算式---
      const tax = Math.floor(inputValue * 0.1);
      //    販売手数料の表示欄の取得
      const addTaxPriceDom = document.getElementById("add-tax-price")
      //    販売手数料の表示
      addTaxPriceDom.innerHTML = tax;
      // ---販売利益の計算式---
      const profit = inputValue - tax;
      //    販売利益の表示欄の取得
      const profitDom = document.getElementById("profit");
      //    販売利益の表示
      profitDom.innerHTML = profit;
  });
};

window.addEventListener('turbo:load', priceInput);
window.addEventListener('turbo:render', priceInput);
