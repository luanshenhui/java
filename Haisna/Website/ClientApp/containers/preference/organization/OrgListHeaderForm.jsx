import React from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';

import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import Button from '../../../components/control/Button';
import { getOrgListRequest, initializeOrgList } from '../../../modules/preference/organizationModule';

const OrgListHeader = (props) => {
  const { history } = props;
  return (
    <ListHeaderFormBase {...props} >
      <div>団体コードもしくは団体名称を入力して下さい。</div>
      <Field name="keyword" component="input" type="text" />
      <div>
        <Button type="submit" value="検索" />
        <Button onClick={() => history.push('/contents/preference/organization/edit')} value="新規登録" />
      </div>
    </ListHeaderFormBase>
  );
};

// propTypesの定義
OrgListHeader.propTypes = {
  history: PropTypes.shape().isRequired,
};

const OrgLisHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'OrgListHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(OrgListHeader);

const mapStateToProps = (state) => ({
  initialValues: { keyword: state.app.preference.organization.organizationList.conditions.keyword },
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    const [page, limit] = [1, 20];
    dispatch(getOrgListRequest({ page, limit, ...conditions }));
  },
  initializeList: () => {
    dispatch(initializeOrgList());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(OrgLisHeaderForm));
