import React from 'react';
import DropDown from './DropDown';

// 検索用文字列

// コンボボックスのアイテムを作成する
const createItem = (value, name) => (
  { value, name: name || value }
);

// 一覧を取得する
const getItems = () => {
  const items = [];

  // A～Zを設定
  for (var i = 65; i <= 90; i++) {
    items.push(createItem(String.fromCharCode(i)));
  }

  // あ段を設定
  items.push(createItem('あ'));
  items.push(createItem('か'));
  items.push(createItem('さ'));
  items.push(createItem('た'));
  items.push(createItem('な'));
  items.push(createItem('は'));
  items.push(createItem('ま'));
  items.push(createItem('や'));
  items.push(createItem('ら'));
  items.push(createItem('わ'));

  // その他を設定
  items.push(createItem('*', 'その他'));

  return items;
}

const items = getItems();

export default (props) => <DropDown {...props} items={items} />;

