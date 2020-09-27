import React from 'react';
import axios from 'axios';

import DropDown from './DropDown';

// 判定分類コンボボックス
const enhance = (WrappedComponent) => class DropDownJudClass extends React.Component {
  constructor(props) {
    super(props);
    this.state = { items: [] };
  }

  componentDidMount() {
    // 判定分類一覧取得
    axios.get('/api/v1/judclasses')
      .then((res) => {
        const items = []

        // アイテムをセット
        res.data.map((rec) => {
          items.push({
            value: rec.judclasscd,
            name: rec.judclassname,
          });
        });

        this.setState({
          items,
        });
      });
  }

  render() {
    return <WrappedComponent {...this.props} items={this.state.items} />
  };
}

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
