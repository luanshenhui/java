import React from 'react';
import PropTypes from 'prop-types';
import { Field, FieldArray, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { getOrgHeaderRequest } from '../../modules/preference/organizationModule';
import styled from 'styled-components';
import Label from '../../components/control/Label';

const Wrapper = styled.div`
  font-size: 1.6em;
  color: #0066cc;
`;

class EditOrgHeaderForm extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
}
  componentWillMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
}

  render() {
    const { data } = this.props;
    const zipcd = data.zipcd;
    let strZipcd;
    if (zipcd != null) {
      strZipcd = <Label> {`${data.zipcd}`.substr(0, 3)} -{`${data.zipcd}`.substr(3, 4)}</Label> 
    }   
    return (
      <div >
        <table>
          <tbody>
            <tr>
              <td>{this.props.match.params.orgcd1}-{this.props.match.params.orgcd2}</td>
              <td>{data.orgkname}</td>
            </tr>
            <tr>
              <td> </td>
              <td><Wrapper><a href={`/contents/preference/organization/edit/${this.props.match.params.orgcd1}/${this.props.match.params.orgcd2}/`}>{data.orgname}</a></Wrapper></td>
            </tr>
            <tr>
              <td></td>
              <td>                               
                {strZipcd}                                  
                {strZipcd===null? "":" "}{data.prefname}{data.cityname}{data.address1}
                {(data.address2===null)? '' :  `${data.address2}`}
                <Label>{(data.tel) ? `TEL：${data.tel}` : ''}</Label>
                <Label>{(data.chargepost === null) && (data.chargename === null) ? "" :"担当："}{(data.chargepost === null) ? '' : `${data.chargepost}`}
                    {(data.chargepost === null) && (data.chargename === null) ? "" : " "}
                    {(data.chargename === null) ? '' : `${data.chargename}`}
                </Label>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      );
    }
}


EditOrgHeaderForm.propTypes = {
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.organization.organizationHeader.data,
});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { orgcd1, orgcd2 } = params;
    dispatch(getOrgHeaderRequest(params));
    },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(EditOrgHeaderForm));
