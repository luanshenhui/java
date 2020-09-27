import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Route } from 'react-router-dom';
import { reduxForm } from 'redux-form';
import PageLayout from '../../../layouts/PageLayout';
import OrgHeader from '../../common/OrgHeader';
import CtrCourseList from './CtrCourseList';
import CtrDetailList from './CtrDetailList';
import { getOrgHeaderRequest } from '../../../modules/preference/organizationModule';

class CtrContrctOrg extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
  }
  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { match, onLoad } = this.props;
    if (match.params.orgcd1 !== nextProps.match.params.orgcd1 || match.params.orgcd2 !== nextProps.match.params.orgcd2) {
      // onLoadアクションの引数として渡す
      onLoad(nextProps.match.params);
    }
  }

  render() {
    const { data, match } = this.props;

    const PageLayoutTitle = () => {
      let title = '';
      const pathname = this.props.location.pathname.split('/');
      if (pathname[pathname.length - 1] === 'courses') {
        title = '契約情報';
      } else {
        title = '契約情報の参照・登録';
      }
      return title;
    };

    return (
      <PageLayout title={PageLayoutTitle()} >
        <OrgHeader {...this.props} data={data} match={match} />
        <Route exact path="/contents/preference/contract/organization/:orgcd1/:orgcd2/courses" component={CtrCourseList} />
        <Route exact path="/contents/preference/contract/organization/:orgcd1/:orgcd2/detail/:cscd/:ctrptcd" component={CtrDetailList} />
      </PageLayout>
    );
  }
}

// propTypesの定義
CtrContrctOrg.propTypes = {
  onLoad: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  data: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
};

const CtrContrctOrgForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'CtrContrctOrg',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,
})(CtrContrctOrg);

// defaultPropsの定義
const mapStateToProps = (state) => ({
  data: state.app.preference.organization.organizationHeader.data,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    dispatch(getOrgHeaderRequest(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CtrContrctOrgForm);
