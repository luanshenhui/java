import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';

export default class ListHeaderFormBase extends React.Component {
  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentWillMount() {
    const { location, onSearch, initializeList } = this.props;

    // 一覧を初期化する
    initializeList();

    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    // オブジェクトが空の場合は何もしない
    if (!Object.keys(params).length) {
      return;
    }
    // オブジェクトが空でなければonSearchアクションの引数として渡す
    onSearch(params);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { location, onSearch } = this.props;
    // ロケーションに変更が発生した場合に検索時イベントを呼び出す
    if (nextProps.location !== location) {
      // qsを利用して変更後ロケーションのquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
      onSearch(qs.parse(nextProps.location.search, { ignoreQueryPrefix: true }));
    }
  }

  // 描画処理
  render() {
    const { handleSubmit, history, match, children } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => {
        // フォームサブミット時はフォームからサーバにデータをpostするのではなく、history.pushによるページ遷移を行わせる
        // これによりcomponentWillReceivePropsメソッドが呼ばれ、その結果、画面の再描画が行われる
        history.push({
          pathname: match.url,
          search: qs.stringify(values),
        });
      })}
      >
        {children}
      </form>
    );
  }
}

// propTypesの定義
ListHeaderFormBase.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.node),
    PropTypes.node,
  ]).isRequired,
};

