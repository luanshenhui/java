import { injectGlobal } from 'styled-components';

const globalStyles = () => (
  injectGlobal`
    * {
      box-sizing: border-box;
      font-family: "メイリオ",Meiryo,"Hiragino Kaku Gothic Pro W3","ヒラギノ角ゴ Pro W3","Hiragino Kaku Gothic Pro","ＭＳ Ｐゴシック",sans-serif;
      margin: 0;
      padding: 0;
      text-decoration: none;
    }

    body {
      color: #333;
      font-size: 14px;
      line-height: 1.6;
    }
  `
);

export default globalStyles;
