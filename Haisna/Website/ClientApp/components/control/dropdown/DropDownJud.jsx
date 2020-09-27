// @flow

import * as React from 'react';

// コンポーネントのインポート
import DropDown from './DropDown';
import judService from '../../../services/preference/judService';

// Type定義
type State = {
  items: Array<{
    value: string,
    name: string,
  }>,
};

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownCourse extends React.Component<{}, State> {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }

  // コンポーネントの初期処理
  componentDidMount() {
    // 判定一覧の取得
    judService.getJudList()
      .then((data) => {
        // 判定一覧をDropDownコンポーネントのitemsプロパティ形式に変換した値でstateを更新する
        const items = data.map((rec) => ({
          value: rec.judcd,
          name: rec.judsname,
        }));
        this.setState({ items });
      });
  }
  // render処理
  render() {
    return (
      <WrappedComponent {...this.props} items={this.state.items} />
    );
  }
};

// DropDownコンポーネント引数に高階関数を呼び出して得られた結果(=継承後のコンポーネント)をエクスポートする
export default enhance(DropDown);
