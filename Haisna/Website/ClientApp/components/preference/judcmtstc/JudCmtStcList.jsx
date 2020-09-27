/**
 * @file 判定コメント一覧
 */
import React from 'react';                                  // Reactそのもの
import { Route, Switch } from 'react-router-dom';           // Reactでルーティングライブラリ
import PropTypes from 'prop-types';                         // プロパティタイプ ライブラリ
import axios from 'axios';                                  // axios(REST API)
import qs from 'qs';                                        // qs(クエリー文字列のパース)

import PageLayout from '../../../layouts/PageLayout';
import Pagination from '../../../components/Pagination';

import JudCmtStcListHeader from './JudCmtStcListHeader';    // 判定コメント一覧ヘッダー
import JudCmtStcListBody from './JudCmtStcListBody';        // 判定コメント一覧ボディ
import JudCmtEdit from './JudCmtStcEdit';                   // 判定コメント登録

export default class JudCmtStcList extends React.Component {

  constructor(props) {
    super(props);

    // 基本ステート設定
    this.state = {
      judclasscd: '',       // 判定分類コード
      judcmtstc: [],        // 判定コメント一覧データ
      page: 1,              // ページ番号
      limit: 10,            // 1ページあたりの最大表示件数
      totalcount: 0,        // 一覧データ数
      pages: 0,             // 最大ページ数
    };

    // イベントハンドルの定義
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleLoad = this.handleLoad.bind(this);
    this.handleSelectPagination = this.handleSelectPagination.bind(this);
  }

  // コンポーネントがマウントされる前に1回だけ呼ばれる処理
  componentWillMount() {
    // クエリー文字列の解析
    const query = qs.parse(this.props.location.search.substr(1));

    // クエリー文字列セット
    this.setState({
      judclasscd: query.judclasscd || this.state.judclasscd,    // 判定分類コード
      page: Number(query.page) || this.state.page,              // 現在のページ
      limit: Number(query.limit) || this.state.limit,           //
    });
  }

  // 一覧データの取得
  getList() {
    const judclasscd = this.state.judclasscd;   // 判定分類コード
    const page = this.state.page;               //
    const limit = this.state.limit;             //

    // 判定コメント一覧取得API呼び出し
    axios
      .get('/api/judcmtstc/', {
        params: {
          judclasscd,       // 判定分類コード
          searchmodeflg: 1, //
          gethihyouji: 1,   //
          page,
          limit,
        },
      })
      .then((res) => {
        const totalcount = res.data.totalcount; // 取得したデータ総数（★？これいる？）
        this.setState({
          judclasscd,                // 判定分類コード
          judcmtstc: res.data.data,  // 判定コメントデータ群
          totalcount,
          page,
          limit,
          pages: Math.ceil(totalcount / limit),
        });
      })
      .catch((error) => {
        if (error.response.status === 404) {
          this.setState({
            judclasscd,             // 判定分類コード
            judcmtstc: [],          // 判定コメントデータ群
            totalcount: 0,
            page,
            limit,
            pages: 0,
          });
          return;
        }
        // eslint-disable-next-line no-alert
        alert(error.response.data.errors[0].message);
      });
  }

  // OnChangeイベント
  handleChange(event) {
    const target = event.target;
    this.setState({ [target.name]: target.value });
  }

  // 画面初期表示
  handleLoad() {
    this.getList();
  }

  // 検索実行
  handleSubmit() {
    this.setState({
      page: 1,
    }, () => this.getList());
  }

  // ページ検索実行
  handleSelectPagination(page) {
    this.setState({
      page,
    }, () => this.getList());
  }

  // レンダリング
  render() {
    return (
      <Switch>
        <Route
          exact
          path={this.props.match.url}
          render={() => (
            <PageLayout title="判定コメント一覧">
              <JudCmtStcListHeader {...this.props} judclasscd={this.state.judclasscd} onChange={this.handleChange} onSubmit={this.handleSubmit} />
              <JudCmtStcListBody {...this.props} judcmtstc={this.state.judcmtstc} onLoad={this.handleLoad} />
              {this.state.pages > 1 &&
                <Pagination
                  onSelect={this.handleSelectPagination}
                  totalCount={this.state.recordcount}
                  startPos={((this.state.page - 1) * this.state.limit) + 1}
                  rowsPerPage={this.state.limit}
                />
              }
            </PageLayout>
          )}
        />
        <Route exact path={`${this.props.match.url}/edit`} component={JudCmtEdit} />
        <Route exact path={`${this.props.match.url}/edit/:judcmtcd`} component={JudCmtEdit} />
      </Switch>
    );
  }
}

// propTypesの定義
JudCmtStcList.propTypes = {
  location: PropTypes.shape({
    search: PropTypes.string.isRequired,
  }).isRequired,
  match: PropTypes.shape().isRequired,
};
