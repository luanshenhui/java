import React from 'react';
import DropDown from './DropDown';
import scheduleService from '../../../services/preference/scheduleService';

// DropDownコンポーネントを継承した高階関数の定義
const enhance = (WrappedComponent) => class DropDownCourseRsvGrp extends React.Component {
  // コンストラクタ
  constructor() {
    super();
    this.state = { items: [] };
  }
  // コンポーネントの初期処理
  componentDidMount() {
    // コース受診予約群をもつコースのみを取得
    const promise = scheduleService.getCourseListRsvGrpManaged();
    promise.then((res) => {
      if (res !== null) {
        // コース受診予約群をDropDownコンポーネントのitemsプロパティ形式に変換
        const items = res.data.map((rec) => ({
          value: rec.cscd,
          name: rec.csname,
        }));

        // stateに格納することでrenderメソッドが呼び出される
        this.setState({ items });
      }
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
