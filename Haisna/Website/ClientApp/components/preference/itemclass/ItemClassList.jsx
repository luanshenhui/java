/**
 * @file 検査分類一覧
 */
import React from 'react';
import { Route, Switch } from 'react-router-dom';
import PropTypes from 'prop-types';
import axios from 'axios';
import qs from 'qs';

import PageLayout from '../../../layouts/PageLayout';
import Pagination from '../../../components/Pagination';

import ItemClassListHeader from './ItemClassListHeader';
import ItemClassListBody from './ItemClassListBody';
import ItemClassEdit from './ItemClassEdit';

export default class ItemClassList extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      itemclasscd: '',
      page: 1,
      limit: 10,
      classname: [],
      totalcount: 0,
      pages: 0,
    };

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
      itemclasscd: query.itemclasscd || this.state.itemclasscd,
      page: Number(query.page) || this.state.page,
      limit: Number(query.limit) || this.state.limit,
    });
  }

  getList() {
    const itemclasscd = this.state.itemclasscd;
    const page = this.state.page;
    const limit = this.state.limit;

    // 検査分類一覧取得API呼び出し
    axios
      .get('/api/itemclass/', {
        params: {
          itemclasscd,
          page,
          limit,
          searchmodeflg: 1,
          gethihyouji: 1,
        },
      })
      .then((res) => {
        const totalcount = res.data.totalcount;
        this.setState({
          classname: res.data.data,
          totalcount,
          itemclasscd,
          page,
          limit,
          pages: Math.ceil(totalcount / limit),
        });
      })
      .catch((error) => {
        if (error.response.status === 404) {
          this.setState({
            classname: [],
            totalcount: 0,
            itemclasscd,
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

  handleChange(event) {
    const target = event.target;
    this.setState({ [target.name]: target.value });
  }

  handleLoad() {
    this.getList();
  }

  handleSubmit() {
    this.setState({
      page: 1,
    }, () => this.getList());
  }

  handleSelectPagination(page) {
    this.setState({
      page,
    }, () => this.getList());
  }

  render() {
    return (
      <Switch>
        <Route
          exact
          path={this.props.match.url}
          render={() => (
            <PageLayout title="検査分類一覧">
              <ItemClassListHeader {...this.props} itemclasscd={this.state.itemclasscd} onChange={this.handleChange} onSubmit={this.handleSubmit} />
              <ItemClassListBody {...this.props} className={this.state.classname} onLoad={this.handleLoad} />
              {this.state.pages > 1 &&
                <Pagination
                  onSelect={this.handleSelectPagination}
                  totalCount={this.state.totalcount}
                  startPos={((this.state.page - 1) * this.state.limit) + 1}
                  rowsPerPage={this.state.limit}
                />
              }
            </PageLayout>
          )}
        />
        <Route exact path={`${this.props.match.url}/edit`} component={ItemClassEdit} />
        <Route exact path={`${this.props.match.url}/edit/:judcmtcd`} component={ItemClassEdit} />
      </Switch>
    );
  }
}

// propTypesの定義
ItemClassList.propTypes = {
  location: PropTypes.shape({
    search: PropTypes.string.isRequired,
  }).isRequired,
  match: PropTypes.shape().isRequired,
};
