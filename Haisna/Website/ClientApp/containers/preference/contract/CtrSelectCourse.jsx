import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import Button from '../../../components/control/Button';
import * as contants from '../../../constants/common';
import PageLayout from '../../../layouts/PageLayout';
import CtrSelectCourseBody from './CtrSelectCourseBody';


class CtrSelectCourse extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
    this.actmode = match.params.actmode;
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  // コンポーネントがアンマウントされる場合の処理
  componentWillUnmount() {
    // フォーム入力内容の初期化
    this.props.reset();
  }
  // 契約コースの選択次へ
  handleSubmit(values) {
    const { history, match, onSubmitBrowse } = this.props;
    // 参照次へ
    onSubmitBrowse(match.params, values, history);
  }
  render() {
    const { history, handleSubmit, match } = this.props;
    return (
      <div>
        {this.props.match.params.actmode === 'browse' && (

          <PageLayout title="契約情報の参照・コピー" >
            <div>
              <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
                <CtrSelectCourseBody actmode={contants.OPMODE_BROWSE} params={match.params} />
                <div style={{ marginTop: '8px' }}>
                  <Button onClick={() => history.push(`/contents/preference/contract/organization/${match.params.orgcd1}/${match.params.orgcd2}/courses`)} value="戻　る" />
                  <Button type="submit" value="次　へ" />
                </div>
              </form>
            </div>
          </PageLayout>

        )}
      </div>
    );
  }
}
const CtrSelectCourseForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'ctrSelectCourse',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
})(CtrSelectCourse);

// プロパティの型を定義する
CtrSelectCourse.propTypes = {
  onSubmitBrowse: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  reset: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = () => ({
  initialValues: {
    opmode: contants.OPMODE_BROWSE,
  },
});

const mapDispatchToProps = () => ({
  onSubmitBrowse: (params, data, history) => {
    const { orgcd1, orgcd2 } = params;
    if (data.cscd === undefined || data.cscd === null) {
      return;
    }
    if (data.opmode === undefined || data.opmode === null) {
      return;
    }
    if (data.opmode === contants.OPMODE_BROWSE) {
      if (orgcd1 === contants.ORGCD1_WEB && orgcd2 === contants.ORGCD2_WEB) {
        history.push(`/contents/preference/contract/${contants.OPMODE_BROWSE}/${orgcd1}/${orgcd2}/${data.cscd}/${contants.ORGCD1_PERSON}/${contants.ORGCD2_PERSON}/refcontracts`);
      } else {
        history.push(`/contents/preference/contract/${contants.OPMODE_BROWSE}/organization/${orgcd1}/${orgcd2}/${data.cscd}`);
      }
    } else {
      history.push(`/contents/preference/contract/${contants.OPMODE_COPY}/${orgcd1}/${orgcd2}/${data.cscd}/period`);
    }
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrSelectCourseForm);
