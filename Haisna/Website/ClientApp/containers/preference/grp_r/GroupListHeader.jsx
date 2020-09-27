import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import qs from 'qs';

import Button from '../../../components/control/Button';
import TextBox from '../../../components/control/TextBox';

import { getGroupListRequest } from '../../../modules/preference/groupModule';

class GroupListHeader extends React.Component {
  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  componentDidMount() {
    const { location, onSearch } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
    onSearch(qs.parse(location.search.substr(1)));
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { location, onSearch } = this.props;
    // ロケーションに変更が発生した場合に検索時イベントを呼び出す
    if (nextProps.location !== location) {
      // qsを利用して変更後ロケーションのquerystringをオブジェクト型に変換し、onSearchアクションの引数として渡す
      onSearch(qs.parse(nextProps.location.search.substr(1)));
    }
  }

  // 描画処理
  render() {
    const { handleSubmit, history, match } = this.props;
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
        <Field name="keyword" component={TextBox} />
        <div style={{ marginTop: 10 }}>
          <Button type="submit" value="検索" />
          <Button onClick={() => history.push('group/edit')} value="新規登録" />
        </div>
      </form>
    );
  }
}

// propTypesの定義
GroupListHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  onSearch: PropTypes.func.isRequired,
};

const GroupListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'groupListHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(GroupListHeader);

const mapStateToProps = (state) => ({
  initialValues: { keyword: state.app.preference.group.groupList.conditions.keyword },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const [page, limit] = [1, 20];
    dispatch(getGroupListRequest({ page, limit, ...conditions }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(GroupListHeaderForm));
