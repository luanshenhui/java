import React from 'react';
import { Link } from 'react-router-dom';

const Home = () => (
  <div style={{ padding: 10 }}>
    <p><a href={'/login'} >ログイン（このリンクを踏まないとセッション情報が有効にならない）</a></p>
    <p><Link to="/preference/maintenance">環境設定</Link></p>
    <p><Link to="/report/report">帳票</Link></p>
    <p><Link to="/sample">サンプル</Link></p>
  </div>
);

export default Home;
