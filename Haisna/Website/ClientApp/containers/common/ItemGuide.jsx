import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

import Button from '../../components/control/Button';
import Pagination from '../../components/Pagination';
import Table from '../../components/Table';
import GuideBase from '../../components/common/GuideBase';

export default class ItemGuide extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      page: 1,
      limit: 15,
      items: [],
      recordcount: 0,
      selectedItems: [],
    };

    this.handleClickRow = this.handleClickRow.bind(this);
    this.handleSelectPagination = this.handleSelectPagination.bind(this);
    this.handleOk = this.handleOk.bind(this);
    this.handleClose = this.handleClose.bind(this);
  }

  // コンポーネントが受け取るpropsが変化した場合に呼び出されるメソッド
  componentWillReceiveProps(nextProps) {
    // 親コンポーネントから渡されたshowプロパティの値がtrue、即ち可視状態となった時点を一覧の取得タイミングとする
    if (nextProps.show) {
      this.getItemList();
    }
  }

  // 検査項目一覧の取得
  getItemList(params = {}) {
    const page = params.page || this.state.page;
    const limit = params.limit || this.state.limit;

    // 検査項目一覧取得API呼び出し
    axios
      .get('/api/v1/items', {
        params: {
          page,
          limit,
        },
      })
      .then((res) => {
        const recordcount = res.data.totalcount;
        // stateを更新することで検査項目一覧の描画が行われる
        this.setState({
          items: res.data,
          recordcount,
          page,
          limit,
          pages: Math.ceil(recordcount / limit),
          selectedItems: this.state.selectedItems,
        });
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
      });
  }

  // paginationのページ選択時の処理
  handleSelectPagination(page) {
    this.getItemList({ page });
  }

  // 行クリック時の処理
  handleClickRow(rec) {
    // 検査項目が未選択であれば選択済み検査項目としてスタックし、選択済みであれば除去する
    const items = Object.assign({}, this.state.selectedItems);
    const code = `${rec.itemcd}-${rec.suffix}`;
    if (!items[code]) {
      items[code] = {
        itemcd: rec.itemcd,
        suffix: rec.suffix,
        itemname: rec.itemname,
        classname: rec.classname,
      };
    } else {
      delete items[code];
    }

    // stateの値を更新する
    this.setState({ selectedItems: items });
  }

  // 指定された検査項目コードが選択済み検査項目として存在するかを判定するメソッド
  isSelected(itemCd, suffix) {
    return `${itemCd}-${suffix}` in this.state.selectedItems;
  }

  // OK時の処理
  handleOk() {
    // 親コンポーネントで定義されたOK時の処理を呼び出す
    if (this.props.onOk) {
      // 選択済み検査項目を配列に変換
      const items = Object.keys(this.state.selectedItems).map((key) => this.state.selectedItems[key]);

      // 配列のソート
      items.sort((value1, value2) => {
        if (value1.itemcd < value2.itemcd) {
          return -1;
        }
        if (value1.itemcd > value2.itemcd) {
          return 1;
        }
        if (value1.suffix < value2.suffix) {
          return -1;
        }
        if (value1.suffix > value2.suffix) {
          return 1;
        }
        return 0;
      });

      // 再度オブジェクトに変換
      const selectedItems = {};
      items.forEach((rec) => {
        const code = `${rec.itemcd}-${rec.suffix}`;
        selectedItems[code] = rec;
      });

      this.props.onOk(selectedItems);
    }

    // クローズ時の処理を呼び出す
    this.handleClose();
  }

  // クローズ時の処理
  handleClose() {
    // stateの初期化
    this.setState({
      page: 1,
      limit: 15,
      items: [],
      recordcount: 0,
      selectedItems: [],
    });

    // 親コンポーネントで定義されたクローズ時の処理を呼び出す
    this.props.onClose();
  }

  render() {
    return (
      <GuideBase visible={this.props.show} title="項目ガイド" onClose={this.handleClose} usePagination={false}>
        <div style={{ overflow: 'auto', height: '600px' }}>
          <Table>
            <thead>
              <tr>
                <th>コード</th>
                <th>名称</th>
                <th>検査分類</th>
              </tr>
            </thead>
            <tbody>
              {this.state.items.map((rec) => (
                <tr key={`${rec.itemcd}-${rec.suffix}`} onClick={() => this.handleClickRow(rec)} className={this.isSelected(rec.itemcd, rec.suffix) ? 'info' : ''}>
                  <td>{rec.itemcd}-{rec.suffix}</td>
                  <td>{rec.itemname}</td>
                  <td>{rec.classname}</td>
                </tr>
              ))}
            </tbody>
          </Table>
          {this.state.pages > 1 &&
            <Pagination
              onSelect={this.handleSelectPagination}
              totalCount={this.state.recordcount}
              startPos={((this.state.page - 1) * this.state.limit) + 1}
              rowsPerPage={this.state.limit}
            />
          }
        </div>
        <div>
          <Button type="submit" onClick={this.handleOk} value="Ok" />
          <Button onClick={this.handleClose} value="キャンセル" />
        </div>
      </GuideBase>
    );
  }
}

// propTypesの定義
ItemGuide.propTypes = {
  show: PropTypes.bool,
  onOk: PropTypes.func,
  onClose: PropTypes.func,
};

// defaultPropsの定義
ItemGuide.defaultProps = {
  show: true,
  onOk: undefined,
  onClose: undefined,
};
