import axios from 'axios';

import DropDown from './DropDown';

// 出力順区分コンボボックス
export default class DropDownOutPriority extends DropDown {
  constructor(props) {
    super(props);

    // 出力順区分一覧の保存変数追加
    this.state = Object.assign(this.state, {
      freelist: [],
    });
  }

  // 一覧取得
  getItems(callback) {
    axios.get('/api/v1/frees',
      {
        params: {
          mode: '1',
          freecd: 'JUDCMTPOT',
        },
      })
      .then((res) => {
        this.setState({
          freelist: res.data.data,
        }, () => {
          const items = [];

          this.state.freelist.forEach((x) => {
            items.push({
              value: x.freefielD1,
              name: `${x.freefielD1}:${x.freefielD2}`,
            });
          });

          callback(items);
        });
      });
  }

  // 初期値設定
  getDefault() {
    // 一覧が取得できなければ空欄を返す
    if (this.state.freelist.length <= 0) {
      return '';
    }

    // 最初の値を取得
    let value = this.state.freelist[0].freefielD1;

    // 順に参照し、初期値指定があればそれを初期値としてセットする
    this.state.freelist.forEach((rec) => {
      if (rec.freefielD3 !== null) {
        value = rec.freefielD1;
      }
    });

    return value;
  }
}
