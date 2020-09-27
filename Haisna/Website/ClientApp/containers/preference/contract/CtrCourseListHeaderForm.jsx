import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import Button from '../../../components/control/Button';
import SectionBar from '../../../components/SectionBar';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDownCourse from '../../../components/control/dropdown/DropDownCourse';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';
import { getAllCtrMngRequest, openCtrCreateWizardGuide } from '../../../modules/preference/contractModule';
import CtrCreateWizard from './CtrCreateWizard';
import * as contants from '../../../constants/common';


class CtrCourseListHeader extends React.Component {
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
    const { formValues, onSubmit, match, headerRefresh } = this.props;
    if (nextProps.headerRefresh !== headerRefresh && nextProps.headerRefresh) {
      onSubmit(match.params, formValues);
    }
  }

  // 表示
  handleSubmit(values) {
    const { match, onSubmit } = this.props;
    onSubmit(match.params, values);
  }
  render() {
    const { history, onOpenCourseGuide, match, handleSubmit } = this.props;
    return (
      <div>
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div>
            <SectionBar title="契約情報の一覧" />
            <div>
              <Button onClick={() => history.push('/contents/preference/contract')} value="戻　る" />
              <Button onClick={() => { onOpenCourseGuide(); }} value="新　規" />
              <Button onClick={() => history.push(`/contents/preference/contract/${match.params.orgcd1}/${match.params.orgcd2}/course/${contants.OPMODE_BROWSE}`)} value="参照コピー" />
            </div>
            <FieldGroup itemWidth={100}>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <Field name="csCd" component={DropDownCourse} mode={1} addblank blankname="すべて" />
              </FieldSet>
              <FieldSet>
                <FieldItem> 受診期間</FieldItem>
                <Field name="strDate" component={DatePicker} /><Label>～ </Label><Field name="endDate" component={DatePicker} />の契約情報を
                <Button type="submit" value="表示" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
        <CtrCreateWizard {...this.props} />
      </div>
    );
  }
}


// propTypesの定義
CtrCourseListHeader.propTypes = {
  history: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onOpenCourseGuide: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  headerRefresh: PropTypes.bool.isRequired,
};

CtrCourseListHeader.defaultProps = {
  formValues: null,
};

const CtrCourseListHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'CtrCourseListHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(CtrCourseListHeader);

const mapStateToProps = (state) => {
  const formValues = getFormValues('CtrCourseListHeader')(state);
  return {
    formValues,
    initialValues: {
      strDate: state.app.preference.contract.contractList.conditions.strDate,
      endDate: state.app.preference.contract.contractList.conditions.endDate,
      orgcd1: state.app.preference.contract.contractList.conditions.orgcd1,
      orgcd2: state.app.preference.contract.contractList.conditions.orgcd2,
    },
    contractList: state.app.preference.contract.contractList,
    headerRefresh: state.app.preference.contract.contractList.headerRefresh,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSubmit: (params, data) => {
    dispatch(getAllCtrMngRequest({ orgcd1: params.orgcd1, orgcd2: params.orgcd2, strDate: data.strDate, endDate: data.endDate, csCd: data.csCd }));
  },
  onLoad: (params) => {
    const strDate = moment().add(-1, 'year').format('YYYY-MM-DD');
    const endDate = moment().add(1, 'year').format('YYYY-MM-DD');
    dispatch(getAllCtrMngRequest({ ...params, strDate, endDate }));
  },
  onOpenCourseGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openCtrCreateWizardGuide());
  },
  initializeList: () => {

  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrCourseListHeaderForm));
