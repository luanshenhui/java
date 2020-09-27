/**
 * @file 管理端末一覧検索領域
 */
import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import { bindActionCreators } from 'redux';

// 標準コンポーネント
import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import Button from '../../../components/control/Button';

// 管理端末モジュール
import * as workStationModules from '../../../modules/preference/workStationModule';

const formName = 'WorkStationListHeader';

// 管理端末一覧検索領域
const WorkStationListHeader = (props) => {
  const { history, workStationActions } = props;

  // 一覧取得処理
  const handleOnSearch = (conditions) => {
    const [page, limit] = [1, 20];
    workStationActions.getWorkStationListRequest({ limit, page, ...conditions });
  };

  return (
    <ListHeaderFormBase
      {...props}
      onSearch={(conditions) => handleOnSearch(conditions)}
      initializeList={() => workStationActions.initializeWorkStationList()}
    >
      <Button onClick={() => history.push('/contents/preference/workstation/edit')} value="新規登録" />
      <Button type="submit" value="検索" />
    </ListHeaderFormBase>
  );
};

// propTypesの定義
WorkStationListHeader.propTypes = {
  // react-router-domのhistory定義
  history: PropTypes.shape().isRequired,
  // react-router-domのmatch定義
  match: PropTypes.shape().isRequired,
  // 管理端末アクション
  workStationActions: PropTypes.shape().isRequired,
};

// redux-form有効化
const WorkStationListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
  initialValues: {
    page: 1,
    limit: 20,
  },
})(WorkStationListHeader);

// mapStateToPropsはconnect処理で必ず必要になるため空の定義を作成する
const mapStateToProps = () => ({});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 管理端末アクション
  workStationActions: bindActionCreators(workStationModules, dispatch),
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(WorkStationListHeaderForm));
